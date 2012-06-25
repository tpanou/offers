<?php

App::uses('CakeEmail', 'Network/Email');

class NewsShell extends AppShell {
    public $uses = array('Student', 'Offer', 'Company');
    public $helpers = array('Html');

    public function main() {

        // default behaviour is to send emails for offers activated the previous
        // day
        $since = date('Y-m-d', strtotime('-1 day'));
        $until = date('Y-m-d');

        $this->within($since, $until);
    }

    // Send a news email for offers with an activation date between $since
    // (inclusive) and $until (exclusive).
    //
    // This is the default behaviour of this Shell.
    //
    // @param $since date
    // @param $until date
    public function within($since, $until) {

        $this->Student->recursive = 0;
        $students = $this->Student->findAllByReceiveEmail('true',
                                                          array('User.email'));

        if (! empty($students)) {

            $offers = $this->get_offers($since, $until);

            if (! empty($offers)) {
                $this->email_news($students, $offers);
            }

        }
    }

    private function get_offers($since, $until) {
        // find offers that were published just yesterday
        $this->Offer->recursive = 2;

        // if you don't like unbind(), just consider this:
        //      Did you know that otherwise, 4 (LEFT JOIN ) queries would be run
        //      when only one is needed?
        $this->Offer->unbindModel(array('hasMany' => array('Coupon',
                                                           'WorkHour',
                                                           'Image')));

        $conditions = array('Offer.started >=' => $since,
                            'Offer.started <' => $until,
                            'Offer.offer_state_id' => STATE_ACTIVE);

        $fields = array('Offer.id',
                        'Offer.title',
                        'Offer.offer_type_id',
                        'Offer.started',
                        'OfferCategory.name',
                        'Company.name');

        $options = array('conditions' => $conditions,
                         'fields' => $fields,
                         'order' => 'Offer.started');

        return $offers = $this->Offer->find('all', $options);

    }

    private function email_news($users, $offers) {

        $email = new CakeEmail('default');
        $email = $email
            ->subject('Νέες προσφορές')
            ->template('new_offers', 'default')
            ->emailFormat('html')
            ->viewVars(array(
                // we need to know the *actual* base url
                // this shell was issued)
                'app_url' => Configure::read('Constants.APP_URL'),
                'offers' => $offers,
            ));

        foreach ($users as $user) {

            $email = $email->to($user['User']['email']);

            try {
                $email->send();
            } catch (Exception $e) {
                //do what with it?
            }
        }
    }

}
