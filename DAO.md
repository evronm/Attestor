# Market DAO

*I fear that if a well designed free market can't defeat Moloch, nothing can and we're all fucked.*

*Which is to say, "we're all fucked."*

*May as well go down fighting, though.  If nothing else, it's more fun than the alternative.*

Market DAO is my idea of how we go down fighting.

The DAO itself is based on two principles:

- A system of structured attestations which is used periodically to produce rewards in the form of fungible tokens.
- A market based voting system.

In order to explain how all this works, we'll need to start with some rigorous(ish) definitions, as the terms standard English offers are confusingly nebulous.

Market Dao starts with of "soul-bound" attestations, used periodically to produce fungible reward tokens.  These tokens, in turn emit expiring voting tokens for each voting event.  I'll try to explain a bit more below.  Let's start with some definitions, as standard English terms can be quite confusing in these matters:

- **Voting Event** -  An event in which token holders vote
- **Voting Token** - An expiring token good for one vote at one voting event.  Burned at vote date if unused.
- **Permanent Token** - Non expiring reward tokens.  They can represent any value desired, but initially their primary pupose is to emit voting tokens when a voting event is called.
- **Attestation** - A statement made by the owner of a wallet about the owner of another wallet (it can actually be the same wallet, but those won't count for much).
- **Structured Attestation** - As the name implies, an attestation with named fields.  
- **Attestation Structure** - A set of field names to be used for structured attestations
- **Attestation Structure Instance** - An attestation structure with values for its fields
- **Reward Formula** - This is a formula used to issue reward tokens based on attestations made.  This transform function should be run on a regular basis.  The reward period, and all reward formulas should be subject to change via voting events.

# Event Sequences in the DAO

## DAO Creation

- A random wallet creates and deploys Factory Contract
- The Factory Contract deploys a multi-asset wallet contract, which it owns.
  - The reason the factory contract currently owns the wallet is that it will need to reassign ownership to a voting contract.  There should be no code in the factory contract that alters the wallet in any other way (Gah!  probaly; it may make more sense to have the factory create a new wallet for each voting event).

## Attestation Structure Creation

- Factory Contract creates an Attestation Structure Contract consisting of a list of field names.
  - Attestation Structure contracts have no owner and all r/w function are available to the public.
  - That said, the field names, once set, are immutable.


## Attestaion Structure Instance Creation

- A specific Attestation Structure Contract creates an instance of itself, consisting of values for its fields
  - Like the structures themselves, structure instances can be created by anyone but once created are immutable.
  - There should probably be functionality here to delete these things as long as no attestations have been made.

## Attestation Creation

- A specific wallet attests that a specific Attestation Structure Instance applies to another wallet
  - Any wallet can make an attestation about any wallet.
  - The plan for the moment is that these cannot be deleted, but of course that can change and allows for variations.

## Reward Formula Vote Proposal Process
**TODO** However: Voting proposals cannot be a free for all.  That would be an enormous headache.  Some idea to limit proposals (this could be a setting, and could even be changeable by a voting event):
  - Only wallets with more than X tokens can propose a vote.
  - Voting proposals require at least X tokens worht of "support"; functionality would need to be built for this.
  - Voting proposals require support from at least X wallets, each of which contains at least Y tokens.


## Treasury transfer Vote Proposal Process
**TODO** However:  Such proposals at minimum will need to include target address, asset types and amounts, and type and number of tokens expected.  
- There is an opportunity here for a kill switch in that the proposal can stipulate sth like "if the proposal passes, the outbound transfer happens, and the expected inbound transfer does not, PANIC!" (provided that "PANIC!" is well defnied)

## Reward Formula Vote Proposal Process
**TODO**

## Reward Award (Periodic and Non-interactive)
- Rewards contract iterates through all active rewards formulas
  - For each formula, it iterates through all the relevant attestations (each reward formula must reference at least one attestation structure instance) and mints the appropriate number of tokens to each attestee

## Voting Event
- At the moment, I only have two types of voting events in mind:
  - Reward formula changes
  - Transfers out of the vault
- The procedure seems to me like it should be the same:
  - Proposal made and approved for voting (procedure TBD)
    - Proposals should include a voting/market period. with a minimum and maximum TBD at creation time.
  - One Voting token is issued for every permanent token in every wallet that holds them.
  - Voting token holders are now free to vote, sell their voting tokens, or do nothing.
    - Voting, of course, entails burning a voting token
  - When the voting/market period ends, votes are tallied (this is, of course, non-interactive but the result will be easily knowable several blocks in advance under most circumstances).
    - If the proposal passes, the funds are transferred in the case of a transfer voting event, or the reward formula is activated/deactivated in the event of a reward change voting event.
    - If the proposal does not pass, nothing happens.  As of now, there should be no state to revert, with the possible exception of deleting the proposal.
    - Regardless of which way the voting event goes, all tokens relating to it that have not already been burned are burned at this point having abstained.

