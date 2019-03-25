pragma solidity ^0.5.6;

interface ITAP {

    /**
    * @dev Return current rightholders balance, this balance show your real action balance
    * @param rightholder <address>
    */
    function rightsOf(address rightholder) external view returns (uint256);

    /**
      * @param _to <address>
      * @param _amount <uint256>
      * @return tr <bool>
      */
    function transferOfRights(address _to, uint256 _amount) external returns(bool);

    function rightToTransfer(address _from, address _to, uint256 _amount) external returns(bool);

    /**
     * @param _to <address>
     * @param _amount <uint256>
     */
    function transferWithRights(address _to, uint256 _amount) external returns(bool);

    /**
    * @dev Call to get your devidents. You need execute func.withdrawalRequest() before.
    */
    function getDividends() external returns (bool);

    // RightsTransfer
    // Emits when rights transfer to new rightholder.
    event RightsTransfer(address indexed from, address indexed to, uint256 indexed amount);
    // RightsTransfer
    // Emits when rights transfer to new rightholder.
    event RightsApproval(address indexed rightholder, address indexed newRightholder, uint tokens);

}