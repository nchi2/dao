```
// SPDX-License-Identifier: GPL-3.0
// 20221123

/*
-- data
안건은 번호, 제목, 내용, 제안자 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
사용자는 자신의 이름과 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보로 이루어져 있습니다.(구조체)

-- function
각 안건의 현재상황(찬,반 투표수)을 알려주는 함수를 구현하세요.
한번 투표한 안건에는 중복으로 투표할 수 없도록 하세요. 기종의 자료구조를 변경해도 됩니다.

--
투표는 누구나 할 수 있습니다. 
투표하는 사람은 제목으로 검색하고 투표를 할 수 있습니다. 
제목과 의사표현을 입력값으로 구현하세요. ?????

아래는 추가문제입니다. 위의 기본문제를 모두 해결한 후에 시간이 남는다면 구현해주세요.
+1) 한번 투표한 안건에는 중복으로 투표할 수 없도록 하세요. (기존의 자료구조를 변경시켜도 됩니다.)
+2) 안건의 투표자가 10명 이상이며 찬성 비율이 70% 이상이면 안건이 통과되도록, 이하면 기각되도록 구현하세요. (추가 배열 등을 구현하셔도 됩니다.)
*/

pragma solidity >=0.7.0 <0.9.0;

contract B2 {
    struct poll {
        uint number;
        string title;
        string contents;
        address by;
        uint agree;
        uint disag;
        Status status;
    }

    enum Status{ongoing, passed, failed}

    // poll[] Polls;
    mapping(string => poll) Polls; // 매핑으로 대체
    uint index;

    struct user {
        string name;
        string[] poll_list; // 내가 올린 안건
        mapping(string=>Voted) voted;
    }

    mapping(address => user) users;
    enum Voted{unvoted, pro, con}

    function setPoll(string memory _title, string memory _contents) public {
        Polls[_title] = poll(index++, _title, _contents, msg.sender, 0,0, Status.ongoing);
        // users는 mapping으로 설정. 지갑주소를 key 값으로 넣으면 value값으로 user 구조체가 반환
        users[msg.sender].poll_list.push(_title); // user 구조체 안에 poll_list에 추가하는 코드
    }

    // poll의 정보 받아오기
    function getPoll(string memory _title) public view returns(poll memory) {
        // 매핑으로 대체되어 _title로 바로 검색
		return Polls[_title];
    }

    // user 설정
    function setUser(string memory _name) public {
        users[msg.sender].name = _name; // users라는 매핑에 msg.sender를 key 값으로 주고 _name을 value값으로 설정
    }

    // user 정보 받아오기, 자기 지갑과 연결된 정보 받아오기
    function getUser() public view returns(string memory) {
        // users 매핑에 msg.sender를 key 값으로 주고 name과 poll_list의 길이(poll_list.length)를 output값으로 설정
        return (users[msg.sender].name);
    }

    function vote(string memory _title, bool _b) public {
        //투표 했는지 확인
        require(users[msg.sender].voted[_title] == Voted.unvoted);
        // 입력한 _title과 각 요소의 title이 일치하는지 확인 (for 문은 이제 필요 없음)
        if(keccak256(bytes(Polls[_title].title)) == keccak256(bytes(_title))) { //title과 _title 비교, string은 직접 비교가 아닌 hash값으로
            // 비교 후 통과하면 찬반여부 판단
            // 찬성이면 
            if(_b == true) {
                // Polls array의 i번 요소의 poll 구조체 내 agree에 숫자 1 추가
                Polls[_title].agree++;
                // user도 자신이 투표한 안건의 결과 데이터를 업데이트 해야함. users mapping을 address로 타고 들어가 user 구조체 내 voted mapping을 건드림.
                users[msg.sender].voted[_title] = Voted.pro;  // voted는 string과 bool로 구성(key -value), _title을 key값으로 넣고 _b를 value 값으로 넣음.
            } else {
                Polls[_title].disag++;
                users[msg.sender].voted[_title] = Voted.con;  
            }
        }
    }

    function finishVote(string memory _title) public {
        if(Polls[_title].agree+Polls[_title].disag >= 10 && 3*Polls[_title].agree >= 7*Polls[_title].disag) {
            Polls[_title].status = Status.passed;
        } else {
            Polls[_title].status = Status.failed;
        }
    }
}
```