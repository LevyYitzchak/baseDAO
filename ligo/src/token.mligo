// SPDX-FileCopyrightText: 2020 TQ Tezos
// SPDX-License-Identifier: LicenseRef-MIT-TQ

// Corresponds to Token.hs module

#include "types.mligo"
#include "token/fa2.mligo"

let call_fa2(param, store : fa2_parameter * storage) : return =
  match param with
    Transfer (p) -> transfer (p, store)
  | Balance_of (p) -> balance_of(p, store)
  | Token_metadata_registry (p) -> token_metadata_registry(p, store)
  | Update_operators (p) -> update_operators(p, store)

let burn(param, store : burn_param * storage) : return =
  not_implemented("burn")

let mint(param, store : mint_param * storage) : return =
  not_implemented("mint")

let transfer_contract_tokens
    (param, store : transfer_contract_tokens_param * storage) : return =
  not_implemented("transfer_contract_tokens")