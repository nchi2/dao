const daovote = artifacts.require("B2");

contract("B2", async () => {
  let vote; // 아래에서 vote를 사용해야하기때문에 미리 선언
  // async : 비동기 함수, 콜백으로 사용
  before(async () => {
    vote = await daovote.new();
  }); //describe를 하기전에 테스트 할 것 = before()
  describe("function test", async () => {
    it("setUser", async () => {
      await vote.setUser("spaceBest choi");
    });
    it("getUser", async () => {
      const result = await vote.getUser();
      assert.equal(result, "spaceBest choi");
    });
  });
});
// contract 함수 안에 첫 아규먼트로 contract 이름, 뒤 콜백 function에는 async 함수를 사용, async 함수안에는 먼저 실행될 함수로 before, 그 뒤로는 describe.
