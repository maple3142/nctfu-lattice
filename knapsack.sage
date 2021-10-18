from Crypto.Util.number import *

flag = b"FLAG{konpeko!}"
m = bytes_to_long(flag)
B = vector([ZZ(getRandomNBitInteger(256)) for _ in range(len(flag) * 8)])

C = B * vector(map(int, f"{m:0112b}"))

print(C)

density = len(B) / log(max(B), 2)
print(density.n())

N = isqrt(len(B)) // 3 * 2
M = matrix.column(N * B)
M = M.augment(
    matrix.identity(len(B)) * 2
)  # use 2 so that we can use BKZ to get better short vector
M = M.stack(vector([-N * C] + [-1] * len(B)))

for row in M.BKZ(
    block_size=24
):  # BKZ is better than LLL with greater block size, but it will be slower too
    if row[0] == 0 and all(-1 <= x <= 1 for x in row[1:]):
        bits = [1 if x == 1 else 0 for x in row[1:]]
        if vector(bits) * B == C:
            print(long_to_bytes(int("".join(map(str, bits)), 2)))
