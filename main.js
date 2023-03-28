
const answers = [
   '58f998155cbd12c2e3812f47f3bd4bf44b571c10048416fa9277abd5d183c4',
   '38d4467b57ef9c6c4fb296111635f657be938c1aa9c99ad77f34df789eba36'
];

document.getElementById('submit-input').value = '';

async function getHash(text)
{
    const uintArray = new TextEncoder().encode(text);
    const hashBuffer = await crypto.subtle.digest('SHA-256', uintArray);
    const bufferArray = Array.from(new Uint8Array(hashBuffer));

    return bufferArray.map(b => b.toString(16)).join('');
}

function verifyFlag()
{
    let text = document.getElementById('submit-input').value;
    if (text == '') return;

    getHash(text).then(result => {
        let asciiElem = document.getElementById('ascii-logo');
        let resultsElem = document.getElementById('flag-results');

        if (answers.includes(result))
        {
            asciiElem.className = 'correct';   
            resultsElem.textContent = "You got it! Nice Job!";
        }
        else
        {
            asciiElem.className = 'incorrect';
            resultsElem.textContent = "Couldn't find a matching flag.";
        }
    });
}

document.getElementById('submit-button').addEventListener('click', () => verifyFlag());
document.getElementById('submit-input').addEventListener('keypress', (e) => {
    if (e.key == 'Enter') verifyFlag();
});

