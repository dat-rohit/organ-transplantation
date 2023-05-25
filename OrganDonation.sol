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

    function validateDonor(Donor _donor) public pure returns(string memory) {

        require(msg.sender=procurement_organization);   //Seul l'organisation chargé du matching donneur-receveur peut valider le patient en tant que donneur potentiel

        //Communication des infos du patient à l'organisation en charge de vérifier s'il peut être donneur potentiel. L'organisation renvoie s'il est éligible ou non
        //.... A implémenter dans le futur
        //

        uint memory _status='1';        //Le status 1 indique que le patient est éligible, 0 sinon
        return _status;

    }

    function validateRecipient(Donor _recipient) public pure returns(string memory) {

        require(msg.sender==procurement_organization);   //Seul l'organisation chargé du matching donneur-receveur peut valider le patient en tant que receveur potentiel

        //Communication des infos du patient à l'organisation en charge de vérifier s'il peut être receveur potentiel. L'organisation renvoie s'il est éligible ou non
        //.... A implémenter dans le futur
        //

        uint memory _status='1';        //Le status 1 indique que le patient est éligible, 0 sinon
        return _status;

    }

    function addRecipient(uint memory _id, string memory _first_name, string memory _last_name, string memory _blood_type, uint memory _age, uint memory _weight, uint memory _height, string _organ_type, string _hospital_location, uint _recipient_date, uint state) public {
        
        require(msg.sender==recipient_hospital);     //Seul l'hopital du receveur peut utiliser la fonction d'ajout

        require(bytes(_first_name).length > 0);
        require(bytes(_last_name).length > 0);
        require(bytes(_blood_type).length > 0);
        require(bytes(_height).length > 0);
        require(bytes(_weight).length > 0);
        require(bytes(_age).length > 0);
        require(bytes(_organ_type).length > 0);
        require(bytes(_id).length > 0);
        require(bytes(_hospital_location).length > 0);
        require(bytes(_recipient_date).length > 0);
        require(bytes(_state).length > 0);



        //On demande à la procurement organization si le patient est éligible
        string memory _status = validateRecipient(Recipient(_id, _first_name, _last_name, _blood_type, _age, _weight, _height, _organ_type, _hospital_location, _recipient_date, state)); 


        
        //S'il est éligible, il est inscrit dans le système
        if(_status==1) {
            recipients[recipientscounter] = Recipient(_id, _first_name, _last_name, _blood_type, _age, _weight, _height, _organ_type, _hospital_location, _recipient_date, _state);
            recipientsCounter++;
        }


        
    }
    
    function addDonor(uint memory _id, string memory _first_name, string memory _last_name, string memory _blood_type, uint memory _age, uint memory _weight, uint memory _height, string _organ_type, string _hospital_location, uint _donor_date) public {
        
        require(msg.sender==donor_hospital);     //Seul l'hopital du receveur peut utiliser la fonction d'ajout

        require(bytes(_first_name).length > 0);
        require(bytes(_last_name).length > 0);
        require(bytes(_blood_type).length > 0);
        require(bytes(_height).length > 0);
        require(bytes(_weight).length > 0);
        require(bytes(_age).length > 0);
        require(bytes(_organ_type).length > 0);
        require(bytes(_id).length > 0);
        require(bytes(_hospital_location).length > 0);
        require(bytes(_donor_date).length > 0);


        //On demande à la procurement organization si le patient est éligible
        string memory _status = validateDonor(Donor(_id, _first_name, _last_name, _blood_type, _age, _weight, _height, _organ_type, _hospital_location, _donor_date)); 


        
        //S'il est éligible, il est inscrit dans le système
        if(_status==1) {
            donors[donorsCounter] = Donor(_id, _first_name, _last_name, _blood_type, _age, _weight, _height, _organ_type, _hospital_location, _donor_date);
            donorsCounter++;
        }


        
    }

    function getDonor(uint _index) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        return (donors[_index].first_name, donors[_index].last_name, donors[_index].age, donors[_index].blood_type, donors[_index].height, donors[_index].weight, donors[_index].organ_type);
    }

    function getRecipient(uint _index) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        return (recipients[_index].first_name, recipients[_index].last_name, recipients[_index].age, recipients[_index].blood_type, recipients[_index].height, recipients[_index].weight, recipients[_index].organ_type);
    }

    


}