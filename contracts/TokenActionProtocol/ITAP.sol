pragma solidity ^0.5.6;


interface ITAP {

    /**
     * @dev Return current rightholders balance, this balance show your real action balance.;
     * @param rightholder balance
     */
    function rightsOf(address rightholder) external view returns (uint256);

    /**
     * @dev Transfer rights. Use when need to sell your active.;
     * @param to recipient
     * @param amount of
     */
    function transferOfRights(address to, uint256 amount) external returns(bool);

    /**
     * @dev Allow another balance spend the current balance.;
     * @param to recipient
     * @param amount of
     */
    function rightToTransfer(address from, address to, uint256 amount) external returns(bool);

    /**
     * @dev Using for transfer tokens with rights.;
     *      Economical function make double send if you need.
     *      Do not use for transfer to exchanges.
     * @param to recipient
     * @param amount of
     */
    function transferWithRights(address to, uint256 amount) external returns(bool);

    /**
     * @dev Call to get your devidents. You need execute func.withdrawalRequest() before.;
     */
    function getDividends() external returns (bool);

    /**
     * @dev Emits when rights transfer to new rightholder.;
     * @param rightholder tx sender
     * @param newRightholder tx spender
     * @param amount tx value
     */
    event RightsTransfer(address indexed rightholder, address indexed newRightholder, uint256 indexed amount);

    /**
     * @dev Emits when rights transfer to new rightholder.;
     * @param rightholder tx sender
     * @param newRightholder tx allowed address
     * @param amount - tx value
     */
    event RightsApproval(address indexed rightholder, address indexed newRightholder, uint amount);

    /**
     * @dev Emits when calculating dividends and crediting to balance.;
     * @param rightholder address
     * @param amount of
     */
    event AccrualDividends(address indexed rightholder, uint amount);

}