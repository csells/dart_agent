function rot13(str) {
  return str.replace(/[a-zA-Z]/g, function(char) {
    const charCode = char.charCodeAt(0);
    // Check case: uppercase A-Z (65-90), lowercase a-z (97-122)
    const base = charCode < 97 ? 65 : 97;
    // Apply ROT13 shift
    return String.fromCharCode(base + (charCode - base + 13) % 26);
  });
}

const encodedString = 'Pbatenghyngvbaf ba ohvyqvat n pbqr-rqvgvat ntrag!';
const decodedString = rot13(encodedString);
console.log(decodedString);
