// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title Math library for liquidity
library LiquidityMath {
    /// @notice Add a signed liquidity delta to liquidity and revert if it overflows or underflows
    /// @param x The liquidity before change
    /// @param y The delta by which liquidity should be changed
    /// @return z The liquidity after the change
    function addDelta(uint128 x, int128 y) internal pure returns (uint128 z) {
        // Wrap the whole body in an unchecked block. V3's overflow checks are
        //       written by hand (the requires below); Solidity 0.8's built-in checks
        //       would fire first with a Panic and change the revert semantics.
        //       unchecked { ... }
        unchecked {
        // If y < 0 (removing liquidity):
        //   
        //       If the subtraction wrapped, z is a huge number >= x, so the require
        //       catches the underflow and reverts with 'LS' (liquidity sub).
        if (y < 0) {
            require((z = x - uint128(-y)) < x, 'LS');
        }
        // (adding liquidity):
        //       If the addition wrapped, z < x, revert with 'LA' (liquidity add).
        else {
            require((z = x + uint128(y)) >= x, 'LA');
        }
        }
    }
}
