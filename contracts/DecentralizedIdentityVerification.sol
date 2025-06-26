// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DecentralizedIdentityVerification {
    struct Identity {
        bytes32 documentHash;
        bool verified;
        address verifier;
    }

    mapping(address => Identity) public identities;
    mapping(address => bool) public approvedVerifiers;

    address public admin;

    event IdentitySubmitted(address indexed user, bytes32 documentHash);
    event IdentityVerified(address indexed user, address indexed verifier);
    event VerifierApproved(address indexed verifier);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyVerifier() {
        require(approvedVerifiers[msg.sender], "Not an approved verifier");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function submitIdentity(bytes32 documentHash) external {
        identities[msg.sender] = Identity(documentHash, false, address(0));
        emit IdentitySubmitted(msg.sender, documentHash);
    }

    function approveVerifier(address verifier) external onlyAdmin {
        approvedVerifiers[verifier] = true;
        emit VerifierApproved(verifier);
    }

    function verifyIdentity(address user) external onlyVerifier {
        require(!identities[user].verified, "Already verified");
        identities[user].verified = true;
        identities[user].verifier = msg.sender;
        emit IdentityVerified(user, msg.sender);
    }

    function isVerified(address user) external view returns (bool) {
        return identities[user].verified;
    }
}
