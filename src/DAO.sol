// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

// From https://archive.trufflesuite.com/guides/chain-forking-exploiting-the-dao/
DAOInterface constant DAO = DAOInterface(0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413);

/// @notice https://github.com/blockchainsllc/DAO/blob/v1.0/Token.sol
/// forge-lint: disable-next-item
/// forgefmt: disable-next-item
interface TokenInterface {
    /// @param _owner The address from which the balance will be retrieved
    /// @return balance The balance
    function balanceOf(address _owner) external view returns (uint256 balance);

    /// @notice Send `_amount` tokens to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to be transferred
    /// @return success Whether the transfer was successful or not
    function transfer(address _to, uint256 _amount) external returns (bool success);
}

/// @notice https://github.com/blockchainsllc/DAO/blob/v1.0/DAO.sol
/// forge-lint: disable-next-item
/// forgefmt: disable-next-item
interface DAOInterface is TokenInterface {
    /// @notice `msg.sender` creates a proposal to send `_amount` Wei to
    /// `_recipient` with the transaction data `_transactionData`. If
    /// `_newCurator` is true, then this is a proposal that splits the
    /// DAO and sets `_recipient` as the new DAO's Curator.
    /// @param _recipient Address of the recipient of the proposed transaction
    /// @param _amount Amount of wei to be sent with the proposed transaction
    /// @param _description String describing the proposal
    /// @param _transactionData Data of the proposed transaction
    /// @param _debatingPeriod Time used for debating a proposal, at least 2
    /// weeks for a regular proposal, 10 days for new Curator proposal
    /// @param _newCurator Bool defining whether this proposal is about
    /// a new Curator or not
    /// @return _proposalID The proposal ID. Needed for voting on the proposal
    function newProposal(
        address _recipient,
        uint _amount,
        string calldata _description,
        bytes calldata _transactionData,
        uint _debatingPeriod,
        bool _newCurator
    ) external payable returns (uint _proposalID);

    /// @notice Vote on proposal `_proposalID` with `_supportsProposal`
    /// @param _proposalID The proposal ID
    /// @param _supportsProposal Yes/No - support of the proposal
    /// @return _voteID The vote ID.
    function vote(
        uint _proposalID,
        bool _supportsProposal
    ) external returns (uint _voteID);

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
}
