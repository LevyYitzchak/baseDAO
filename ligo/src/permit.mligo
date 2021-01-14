// SPDX-FileCopyrightText: 2020 TQ Tezos
// SPDX-License-Identifier: LicenseRef-MIT-TQ

// Corresponds to Permit.hs module

// Complete parameter with common signature data and pack them bytes that
// will be signed in permit.
//
// This slightly differs from the Haskell version in that it already
// returns packed data; LIGO does not let us return polymorphic DataToSign.
[@inline]
let vote_param_to_signed_data (param, store : vote_param * storage): bytes * storage =
  ( Bytes.pack
    ( (Tezos.chain_id, Tezos.self_address)
    , (store.permits_counter, param)
    )
  , { store with permits_counter = store.permits_counter + 1n }
  )

// Get the implicit address of the author who signed the permit.
[@inline]
let permit_sender (permit : permit): address =
  Tezos.address (Tezos.implicit_account (Crypto.hash_key (permit.key)))

// Check that data matches the permit.
[@inline]
// TODO: proper errors
let check_permit (permit, data_to_sign : permit * bytes): bool =
  Crypto.check permit.key permit.signature data_to_sign

// Check that permit is signed by its author, and return the author
// and the parameter to work with.
[@inline]
let verify_permit_vote (permit, vote_param, store : permit * vote_param * storage)
    : (vote_param * address * storage) =
  let (data_to_sign, store) = vote_param_to_signed_data (vote_param, store) in
  let checked =
    if check_permit (permit, data_to_sign)
      then ()
      else failwith("MISSIGNED")
    in
  (vote_param, permit_sender permit, store)

// Check that permit is signed by its author, and return the data
// carried under permit protection.
[@inline]
let verify_permit_protected_vote
    (permited, store : vote_param_permited * storage)
    : vote_param * address * storage =
  match permited.permit with
    None -> (permited.argument, Tezos.sender, store)
  | Some permit -> verify_permit_vote (permit, permited.argument, store)