pragma solidity ^0.8.7;

//making a voting contract

//1. we want ability to accept proposals and store them
//proposals:their name,number

//2.voters and voting ability
//keep track of voting
//check voters are authemticated to vote

//3. chairman
//authenticate and deploy contract

contract Ballot {

    struct Voter {
        uint vote;
        bool voted;
        uint weight;
    }

    struct Proposal{
        bytes32 name;
        uint voteCount; //no. of accumulated vote

    }

    Proposal[] public proposals;

    mapping(address => Voter) public voters; //voters get address as a key and Voter for value
    address public chairperson;

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        for(uint i =0; i <proposalNames.length; i++){
            proposals.push(Proposal({
                name : proposalNames[i],
                voteCount: 0

            }));
        }
    }

    //function Authenticate Voter

    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson , 'Only The Chairperson can give access to vote');
        require(!voters[voter].voted, 'The Voter has already Voted');
        require(voters[voter].weight ==0);

        voters[voter].weight = 1;
    }

        //function for voting 
        function vote(uint proposal) public{
            Voter storage sender = voters[msg.sender];
            require(sender.weight != 0, 'Has no right to vote');
            require(!sender.voted , 'Already Voted');
            sender.voted = true;
            sender.vote = proposal;

            proposals[proposal].voteCount = proposals[proposal].voteCount + sender.weight;

        }

        //function for sharing the results 
        function winningProposal() public view returns(uint winningProposal_){

            uint winningVoteCount = 0;
            for(uint i =0; i < proposals.length; i++){

                if(proposals[i].voteCount > winningVoteCount){
                    winningVoteCount =  proposals[i].voteCount;
                    winningProposal_ = i;

                }
            }


        }
        //function that shows the winner by name 
        function winningName() public view returns(bytes32 winningName_){

            winningName_ = proposals[winningProposal()].name;



        }

    }
