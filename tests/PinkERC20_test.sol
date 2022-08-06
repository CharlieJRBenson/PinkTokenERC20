// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "../.deps/remix-tests/remix_tests.sol";
import "../contracts/PINK_TOKEN.sol";

contract PinkERC20Test {

    PinkToken p;
    function beforeAll () public {
        p = new PinkToken();
    }

    function testTokenNameAndSymbol () public {
        Assert.equal(p.name(), "Pink", "token name did not match");
        Assert.equal(p.symbol(), "PINK", "token symbol did not match");
    }
}