
async function getHash(text)
{
    const uintArray = new TextEncoder().encode(text);
    const hashBuffer = await crypto.subtle.digest('SHA-256', uintArray);
    const bufferArray = Array.from(new Uint8Array(hashBuffer));

    return bufferArray.map(b => b.toString(16)).join('');
}

export { getHash };
