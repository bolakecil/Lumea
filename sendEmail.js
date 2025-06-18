require('dotenv').config({ path: './ath.env' });
const nodemailer = require('nodemailer');
const multer = require('multer');



const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

async function start(req, res){
    const { to } = req.body; // 👈 get recipient email from Swift app
    const file = req.file; // 👈 get file from Swift app 

    const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 465,
        secure: true,
        auth:{
            user: process.env.EMAIL_USER || "",
            pass: process.env.EMAIL_PASS || "" 
        }
    })
    
    const mailOptions =  {
        from: `"Nicholas Chao" <${process.env.EMAIL_USER}>`,
        to: to, // 👈 use the recipient email from Swift app
        subject: 'Lumea Skin Analysis Report',
        text: 'Please find attached your skin analysis report.',
        attachments: file ? [
            {
                filename: 'Skin_Analysis_Report.jpg',
                content: file.buffer, // 👈 use the file buffer from Swift app
                contentType: file.mimetype // 👈 use the file mimetype from Swift app
            }
        ] : []
    }

    try {
        const info = await transporter.sendMail(mailOptions);
        console.log(info.messageId);
        res.status(200).json({ message: 'Email sent successfully', messageId: info.messageId });

    } catch (error) {
        console.error('Error sending email:', error);
        res.status(500).json({ error: 'Failed to send email' });
    }


    // console.log(info.messageId);
    // console.log('Email sent successfully');
    // return info;
}

module.exports = { start, upload }
// start()