module example::eme_coin;

use sui::balance::Balance;
use sui::clock::Clock;
use sui::coin::{Self, TreasuryCap, Coin};
use sui::tx_context::sender;


const SUPPLY_CAP: u64 = 1_000_000_000;
const LOCK_UP_DURATION: u64 = 24 * 60 * 60 * 1000;

public struct Wallet has key, store {
    id: UID,
    balance: Balance<EME_COIN>,
    start: u64,
	claimed: u64,
	duration: u64,
}

public struct EME_COIN has drop {}

fun init(otw: EME_COIN, ctx: &mut TxContext) {
    let (treasury_cap, metadata) = coin::create_currency<EME_COIN>(
        otw,
        8,
        b"EME COIN",
        b"EME",
        b"https://github.com/NivraLabs/Sui-QSG",
        option::none(),
        ctx,
    );
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury_cap, ctx.sender())
}

public fun mint(
    treasury_cap: &mut TreasuryCap<EME_COIN>,
    clock: &Clock,
    ctx: &mut TxContext
): Wallet {
    let coin = treasury_cap.mint(SUPPLY_CAP, ctx);
    let start_date = clock.timestamp_ms();

    Wallet {
        id: object::new(ctx),
        balance: coin.into_balance(),
        start: start_date,
        claimed: 0,
        duration: LOCK_UP_DURATION
    }
}

public fun claim (
    self: &mut Wallet,
    clock: &Clock,
    ctx: &mut TxContext
): Coin<EME_COIN> {
    let claimable_amount = self.claimable(clock);
    self.claimed = self.claimed + claimable_amount;

	coin::from_balance(self.balance.split(claimable_amount), ctx)
}

public fun claimable(
    self: &Wallet,
    clock: &Clock
): u64 {
    let timestamp = clock.timestamp_ms();

	if (timestamp >= self.start + self.duration) return self.balance.value();

    let elapsed_time = timestamp - self.start;

    let claimable: u128 = (self.balance.value() + self.claimed as u128) * (elapsed_time as u128) 
        / (self.duration as u128);

    (claimable as u64) - self.claimed
}