// pragma experimental ABIEncoderV2
//SPDX-License-Identifier: <SPDX-License>
pragma solidity ^0.6.1;
pragma experimental ABIEncoderV2;

//todo: fonction processus de matching
//todo: interface simple connecté

contract DonorRecipientMatch {

    uint public recipientsCounter=0;      //Compteur: nombre de receveurs inscrits dans le système
    uint public donorsCounter=0;          //Compteur: nombre de donneurs inscrits dans le système

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

    function validateDonor(Donor memory _donor) public pure returns(uint) {

        //require(msg.sender=procurement_organization);   //Seul l'organisation chargé du matching donneur-receveur peut valider le patient en tant que donneur potentiel

        //Communication des infos du patient à l'organisation en charge de vérifier s'il peut être donneur potentiel. L'organisation renvoie s'il est éligible ou non
        //.... A implémenter dans le futur
        //

        uint _status=1;        //Le status 1 indique que le patient est éligible, 0 sinon
        return _status;

    }

    function validateRecipient(Recipient memory _recipient) public pure returns(uint) {

        //require(msg.sender==procurement_organization);   //Seul l'organisation chargé du matching donneur-receveur peut valider le patient en tant que receveur potentiel

        //Communication des infos du patient à l'organisation en charge de vérifier s'il peut être receveur potentiel. L'organisation renvoie s'il est éligible ou non
        //.... A implémenter dans le futur
        //

        uint _status=1;        //Le status 1 indique que le patient est éligible, 0 sinon
        return _status;

    }

    function addRecipient(uint _id, string memory _firstname, string memory _lastname, string memory _bloodtype, uint _age, uint _weight, uint _height, string memory _organtype, string memory _hospitallocation, uint _recipientdate, uint _state) public {
        
        //require(msg.sender==recipient_hospital);     //Seul l'hopital du receveur peut utiliser la fonction d'ajout

        require(bytes(_firstname).length > 0);
        require(bytes(_lastname).length > 0);
        require(bytes(_bloodtype).length > 0);
        require(bytes(_organtype).length > 0);
        require(bytes(_hospitallocation).length > 0);



        //On demande à la procurement organization si le patient est éligible
        uint _status = validateRecipient(Recipient(_id, _firstname, _lastname, _bloodtype, _age, _weight, _height, _organtype, _hospitallocation, _recipientdate, _state)); 


        
        //S'il est éligible, il est inscrit dans le système
        if(_status==1) {
            recipients[recipientsCounter] = Recipient(_id, _firstname, _lastname, _bloodtype, _age, _weight, _height, _organtype, _hospitallocation, _recipientdate, _state);
            recipientsCounter++;
        }


        
    }
    
    function addDonor(uint _id, string memory _firstname, string memory _lastname, string memory _bloodtype, uint _age, uint _weight, uint _height, string memory _organtype, string memory _hospitallocation, uint _donordate) public {
        
        //require(msg.sender==donor_hospital);     //Seul l'hopital du receveur peut utiliser la fonction d'ajout

        require(bytes(_firstname).length > 0);
        require(bytes(_lastname).length > 0);
        require(bytes(_bloodtype).length > 0);
        require(bytes(_organtype).length > 0);
        require(bytes(_hospitallocation).length > 0);
      


        //On demande à la procurement organization si le patient est éligible
        uint _status = validateDonor(Donor(_id, _firstname, _lastname, _bloodtype, _age, _weight, _height, _organtype, _hospitallocation, _donordate)); 


        
        //S'il est éligible, il est inscrit dans le système
        if(_status==1) {
            donors[donorsCounter] = Donor(_id, _firstname, _lastname, _bloodtype, _age, _weight, _height, _organtype, _hospitallocation, _donordate);
            donorsCounter++;
        }


        
    }

 //   function getDonor(uint _index) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
//     return (donors[_index].first_name, donors[_index].last_name, donors[_index].age, donors[_index].blood_type, donors[_index].height, donors[_index].weight, donors[_index].organ_type);
//    }
//
//    function getRecipient(uint _index) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
//        return (recipients[_index].first_name, recipients[_index].last_name, recipients[_index].age, recipients[_index].blood_type, recipients[_index].height, recipients[_index].weight, recipients[_index].organ_type);
//    }



    //Algorithme de selection des receveurs potentiels
    function compare(Donor memory d, Recipient memory r) internal pure returns (bool) {
        if (keccak256(bytes(d.blood_type)) != keccak256(bytes(r.blood_type))) {
            // Blood types don't match
            return false;
        }

        if (d.age < r.age-10 || r.age+10<d.age) {
            // age du donneur trop loin de celui du receveur
            return false;
        }

        if (d.weight < r.weight-20 || d.weight > r.weight + 20) {
            // Poids du donneur trop loin de celui du receveur
            return false;
        }

        if (keccak256(bytes(d.organ_type)) != keccak256(bytes(r.organ_type))) {
            // Organ types don't match
            return false;
        }

        // All attributes match, it's a potential match
        return true;
    }


    //Tri des receveurs potentiels du plus prioritaire au moins prioritaire
     function sort(Recipient[] memory matches) internal pure {
        uint n = matches.length;
        for (uint i = 0; i < n - 1; i++) {
            for (uint j = 0; j < n - i - 1; j++) {
                if (matches[j].recipient_date < matches[j + 1].recipient_date) {
                    swap(matches, j, j + 1);
                } else if (matches[j].recipient_date == matches[j + 1].recipient_date) {
                    if (matches[j].state < matches[j + 1].state) {
                        swap(matches, j, j + 1);
                    }
                }
            }
        }
    }

    //Fonction auxiliaire pour échanger 2 elements d'un tableau
    function swap(Recipient[] memory arr, uint i, uint j) internal pure {
        Recipient memory temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }



    //Fonction appelable par le procurement organization pour trouver des receveurs potentiels étant donné un donneur
    function matchAlgo(uint donorId) public returns(Recipient[] memory) {

        //require(msg.sender==procurement_organization)

        Recipient[] memory matches = new Recipient[](recipientsCounter);
        uint matchCount=0;

        for (uint i = 0; i < recipientsCounter; i++) {
            Recipient memory recipient = recipients[i];

            if (compare(donors[donorId], recipient)) {
                matches[matchCount] = recipient;
                matchCount++;
            }
        }

        assembly {
            mstore(matches, matchCount)
        }

        sort(matches);
        return matches;

    }


}