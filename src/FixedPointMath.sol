//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library FixedPointMath {
    uint256 internal constant wad = 1e18;

    function mulWad(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulDiv(x, y, wad);
    }

    function divWad(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulDiv(x, wad, y);
    }

    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y
            // Compute the product mod 2^256 and mod 2^256 - 1
            uint256 prod0;
            uint256 prod1;
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Non-overflow case: high part is zero
            if (prod1 == 0) {
                require(denominator > 0, "DIV_BY_ZERO");
                assembly {
                    result := div(prod0, denominator)
                }
                return result;
            }

            // denominator must be > prod1 or result overflows 256 bits
            require(denominator > prod1, "OVERFLOW");

            // Make division exact by subtracting remainder

            uint256 remainder;
            assembly {
                remainder := mulmod(x, y, denominator)
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator

            uint256 twos = denominator & (~denominator + 1);
            assembly {
                denominator := div(denominator, twos)
                prod0 := div(prod0, twos)
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0
            prod0 |= prod1 * twos;

            // Compute modular inverse of denominator

            uint256 inv = (3 * denominator) ^ 2;
            inv *= 2 - denominator * inv; // inverse mod 2^8
            inv *= 2 - denominator * inv; // 2^16
            inv *= 2 - denominator * inv; // 2^32
            inv *= 2 - denominator * inv; // 2^64
            inv *= 2 - denominator * inv; // 2^128
            inv *= 2 - denominator * inv; // 2^256

            // Final multiply to get the result

            result = prod0 * inv;
        }
    }
}
