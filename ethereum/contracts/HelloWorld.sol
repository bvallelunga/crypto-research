// Hello World Contract
pragma solidity ^0.4.19;

contract HelloWorld {
    string word;
    
    function HelloWorld(string initWord) public{ 
        word = initWord; 
    }
    
    function registerWord(string newWord) public { word  = newWord; }
    function getWord() public constant returns(string curWord) { curWord = word;}

}
