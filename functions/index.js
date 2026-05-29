const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "rodrigomarcac@gmail.com",
    pass: "pgov ecyw gqxs zjqh",
  },
});

exports.sendNotificationEmail = functions.firestore
  .document("notifications/{notificationId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    const mailOptions = {
      from: `Cerberus Pet Spa <rodrigomarcac@gmail.com>`,
      to: data.email,
      subject: data.title,
      html: `
        <div style="font-family: Arial; padding: 20px;">
          <h1 style="color:#66c7d8;">
            Cerberus Pet Spa
          </h1>

          <h2>${data.title}</h2>

          <p style="font-size:16px;">
            ${data.message}
          </p>

          <hr>

          <p>
            Gracias por confiar en nosotros.
          </p>
        </div>
      `,
    };

    try {
      await transporter.sendMail(mailOptions);

      console.log("EMAIL ENVIADO");
    } catch (error) {
      console.error("ERROR EMAIL:", error);
    }
  });