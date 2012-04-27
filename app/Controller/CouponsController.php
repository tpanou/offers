<?php

class CouponsController extends AppController {

    public $name = 'coupons';
    public $uses = array('Coupon', 'Offer');

    public function beforeFilter() {
        if (! $this->is_authorized($this->Auth->user()))
            throw new ForbiddenException();

        parent::beforeFilter();
    }

    public function add () {
        if ($this->Auth->User('role') !== ROLE_STUDENT)
            throw new ForbiddenException();

        if (empty($this->request->data))
            throw new BadRequestException();

        // do not work on the request object
        $coupon_data = $this->request->data;

        // don't read from session all the time
        $student_id = $this->Session->read('Auth.Student.id');
        $offer_id = $coupon_data['Coupon']['offer_id'];

        // check if user is allowed to get the coupon due to maximum
        // coupon number acquired
        if ($this->Coupon->max_coupons_reached($offer_id, $student_id)) {
            // TODO: make this a non 500 error
            throw new MaxCouponsException('Έχετε δεσμεύσει τον μέγιστο ' .
                'αριθμό κουπονιών για αυτήν την προσφορά.');
        }

        // create a unique id
        $coupon_data['Coupon']['serial_number'] = $this->generate_uuid();

        $coupon_data['Coupon']['is_used'] = 0;
        $coupon_data['Coupon']['student_id'] = $student_id;

        if ($this->Coupon->save($coupon_data))
            $this->Session->setFlash('Το κουπόνι δεσμεύτηκε επιτυχώς',
                                     'default',
                                     array('class' => Flash::Success));
        else
            $this->Session->setFlash('Παρουσιάστηκε κάποιο σφάλμα',
                                     'default',
                                     array('class' => Flash::Error));

        $this->redirect($this->referer());
    }

    private function generate_uuid() {
        $uuid = sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000, mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff));

        return $uuid;
    }

    public function is_authorized($user) {
        if ($user['is_banned'] == 0) {
            if ($this->action === 'add') {
                // only students can get coupons
                if ($user['role'] !== ROLE_STUDENT)
                    return false;
                return true;
            }
        }

        // admin can see banned users too
        return parent::is_authorized($user);
    }

}

class MaxCouponsException extends CakeException {};
