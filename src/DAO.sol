// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

// From https://archive.trufflesuite.com/guides/chain-forking-exploiting-the-dao/
DAOInterface constant DAO = DAOInterface(0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413);

/// @notice https://github.com/blockchainsllc/DAO/blob/v1.0/DAO.sol
/// forge-lint: disable-next-item
/// forgefmt: disable-next-item
interface DAOInterface {
    /// @notice ATTENTION! I confirm to move my remaining ether to a new DAO
    /// with `_newCurator` as the new Curator, as has been
    /// proposed in proposal `_proposalID`. This will burn my tokens. This can
    /// not be undone and will split the DAO into two DAO's, with two
    /// different underlying tokens.
    /// @param _proposalID The proposal ID
    /// @param _newCurator The new Curator of the new DAO
    /// @dev This function, when called for the first time for this proposal,
    /// will create a new DAO and send the sender's portion of the remaining
    /// ether and Reward Tokens to the new DAO. It will also burn the DAO Tokens
    /// of the sender.
    function splitDAO(
        uint _proposalID,
        address _newCurator
    ) external returns (bool _success);

    /// @param _owner The address from which the balance will be retrieved
    /// @return balance The balance
    function balanceOf(address _owner) external pure returns (uint256 balance);
}
