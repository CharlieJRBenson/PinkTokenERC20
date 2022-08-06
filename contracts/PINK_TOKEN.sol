// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.2/access/Ownable.sol";

contract PinkToken is ERC20, Ownable {

    // Max supply as 1 Billion
    uint256 public MAX_SUPPLY = 1000000000;

    // `LOCK` bool determines if transfer capacity is locked.
    // Initialised as Unlocked for LP.
    // After is flipped to Locked.
    // After initial sale (approx 10mins) -> unlocked and ownership is renounced.    
    // Max transfer volume can be locked for initial sales
    bool public LOCK = false;
    uint256 public MAX_TRANSFER;


    constructor() ERC20("Pink", "PINK") {        
        _mint(msg.sender, MAX_SUPPLY * 10 ** decimals());
        // initialises maximum transfer volume to 25 mil tokens
        MAX_TRANSFER = 25000000 * 10 ** decimals();
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     * - the caller must not be transferring more than MAX_TRANSFER while LOCK is true.
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(!LOCK || amount <= MAX_TRANSFER, "ERROR - Temporary Transfer Limit Reached");
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     * - the caller must not be transferring more than MAX_TRANSFER while LOCK is true.
     *
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        require(!LOCK || amount <= MAX_TRANSFER, "ERROR - Temporary Transfer Limit Reached");

        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    // alters the `MAX_TRANSFER` variable, preventing fast buying and selling
    // utilised in early launch stages ONLY
    function changeMaxTransfer(uint256 amount) public onlyOwner returns(uint256){
        require(amount <= MAX_SUPPLY || amount >= 0 ,"ERROR - Invalid Value");
        
        MAX_TRANSFER = amount;
        return amount;
    }

    // toggles `LOCK` variable between true and false
    // when false: there is freedom to transfer any token amount 
    // `LOCK = true` in early launch stages ONLY
    function flipLock() public onlyOwner returns(bool){
        LOCK = !LOCK;
        return(LOCK);
    }
}
