/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// functions/index.js
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const admin = require('firebase-admin');

admin.initializeApp();


exports.createMsg = onDocumentCreated(
  "chat/{msgId}", // caminho do documento
  async (event) => {
    // em v2 o payload vem em event.data
    //logger.log("Nova mensagem criada:", event.data);

    const data = event.data;

    // await admin.messaging().send("chat", {
    //     notification: {
    //         title: event.data().userName,
    //         body: event.data().text,
    //         clickAction: 'FLUTTER_NOTIFICATION_CLICK',
    //     }
    // })
    // **Note**: `sendToTopic` é da API v1. Em v2, você constrói a mensagem e usa `admin.messaging().send()`
    const message = {
      topic: "chat",
      notification: {
        title: data.userName,
        body:  data.text,
      },
      android: {
        notification: {
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        }
      },
      apns: {
        payload: {
          aps: {
            "category": "FLUTTER_NOTIFICATION_CLICK"
          }
        }
      }
    };

    // envia e aguarda
    const response = await admin.messaging().send(message);
    logger.log("Sent notification:", response);
  }
);

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
