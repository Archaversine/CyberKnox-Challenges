
nothing_important = 'hAbf@Giu*gaJivhr$qy1o3rcnawpe:SNnY8silnsv'

def encrypt(plaintext: str) -> list:
    return [ord(x) ^ ord(nothing_important[i]) for i, x in enumerate(plaintext)]


def decrypt(encrypted: list) -> str:
    return ''.join([chr(x ^ ord(nothing_important[i])) for i, x in enumerate(encrypted)])


if __name__ == '__main__':

    text = input('Enter string to encrypt: ')
    print(f'Your encrypted bytes are: {encrypt(text)}')
