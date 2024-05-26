// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SurveyContract {
    struct Survey {
        uint id;
        string question; // String soru
        bool isRatingSurvey; // Anket tipini belirler: true ise puanlama, false ise metin yanıtlı
        mapping(uint => uint) ratings; // Puanlamaları saklar
        string[] responses; // Metin yanıtlarını saklar
        mapping(address => bool) hasVoted; // Kullanıcının oylama yapılıp yapılmadığını kontrol eder
    }

    Survey[] public surveys;
    uint public nextId;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }

    // Puanlama anketi oluşturur
    function createRatingSurvey(string memory _question) public onlyOwner {
        Survey storage newSurvey = surveys.push();
        newSurvey.id = nextId;
        newSurvey.question = _question;
        newSurvey.isRatingSurvey = true;
        nextId++;
    }

    // Metin yanıtlı anket oluşturur
    function createTextResponseSurvey(string memory _question) public onlyOwner {
        Survey storage newSurvey = surveys.push();
        newSurvey.id = nextId;
        newSurvey.question = _question;
        newSurvey.isRatingSurvey = false;
        nextId++;
    }

    // Puanlama yapar
    function rateSurvey(uint _surveyId, uint _rating) public {
        require(surveys[_surveyId].isRatingSurvey, "This survey is not a rating survey.");
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5.");
        require(!surveys[_surveyId].hasVoted[msg.sender], "You have already voted.");
        surveys[_surveyId].ratings[_rating]++;
        surveys[_surveyId].hasVoted[msg.sender] = true;
    }

    // Metin yanıtı gönderir
    function respondToSurvey(uint _surveyId, string memory _response) public {
        require(!surveys[_surveyId].isRatingSurvey, "This survey is not a text response survey.");
        require(!surveys[_surveyId].hasVoted[msg.sender], "You have already voted.");
        surveys[_surveyId].responses.push(_response);
        surveys[_surveyId].hasVoted[msg.sender] = true;
    }

    // Belirli bir anketin tüm puanlamalarını getirir
    function getSurveyRatings(uint _surveyId) public view returns (uint[5] memory ratings) {
        require(surveys[_surveyId].isRatingSurvey, "This survey is not a rating survey.");
        for (uint i = 1; i <= 5; i++) {
            ratings[i-1] = surveys[_surveyId].ratings[i];
        }
        return ratings;
    }

    // Belirli bir anketin tüm metin yanıtlarını getirir
    function getSurveyResponses(uint _surveyId) public view returns (string[] memory) {
        require(!surveys[_surveyId].isRatingSurvey, "This survey is not a text response survey.");
        return surveys[_surveyId].responses;
    }

    // Oylama kontrolü yapar
    function hasVoted(uint _surveyId, address _voter) public view returns (bool) {
        return surveys[_surveyId].hasVoted[_voter];
    }
}