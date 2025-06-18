const express = require('express');
const cors = require('cors');
const { start, upload } = require('./sendEmail'); // import your function

const app = express();
const PORT = 3000;

app.use(cors());

app.post('/sendEmail', upload.single('attachment'), start); // delegate to your own function

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on http://0.0.0.0:${PORT}`);

});
  
