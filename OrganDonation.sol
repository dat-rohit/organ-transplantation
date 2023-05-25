// pragma experimental ABIEncoderV2
//SPDX-License-Identifier: <SPDX-License>
pragma solidity ^0.6.1;


contract DonorRecipientMatch {

    uint public recipientsCounter=0;      //Compteur: nombre de receveurs inscrits dans le système
    uint public donorsCounter=0;          //Compteur: nombre de doneurs inscrits dans le système

    mapping(uint => Recipient) public recipients;
    mapping(uint => Donor) public donors;

    address recipient_hospital;
    address donor_hospital;
    address procurement_organization;




    struct Donor {                        //Une structure pour représenter chaque donneur inscrit

        uint id;
        string first_name;
        string last_name;
        string blood_type;
        uint age;
        uint weight;
        uint height;
        string organ_type;
        string hospital_location;
        uint donor_date;                //Date à laquelle le donneur s'est inscrit  

    }

    struct Recipient {                   //Une structure pour représenter chaque receveur inscrit

        uint id;
        string first_name;
        string last_name;
        string blood_type;
        uint age;
        uint weight;
        uint height;
        string organ_type;
        string hospital_location;

        uint recipient_date;          //Date depuis laquelle le receveur atteint un don
        uint state;                    //Urgence médicale du receveur:1, 2 ou 3

    }

 
    


}