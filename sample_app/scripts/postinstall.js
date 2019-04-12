var fs = require('fs');
var path = require('path');

function copyFolderSync(from, to) {
    fs.mkdirSync(to);
    fs.readdirSync(from).forEach(element => {
        if (fs.lstatSync(path.join(from, element)).isFile() && !element.startsWith('.')) {
            fs.copyFileSync(path.join(from, element), path.join(to, element));
        } else if (element !== 'sample_app' && !element.startsWith('.')) {
            copyFolderSync(path.join(from, element), path.join(to, element));
        }
    });
}

var filePath = path.join(__dirname, '..', 'node_modules', 'react-native-nearbee');
fs.unlinkSync(filePath);
var source = path.join(__dirname, '..', '..');
copyFolderSync(source, filePath);