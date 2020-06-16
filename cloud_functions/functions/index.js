const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp(functions.config().firebase)

var fireStore = admin.firestore()

exports.calculateAverage = functions.https.onRequest(async (request, response) => {
  var university = request.query.university;
  var department = request.query.department;
  var lecture = request.query.lecture;
  var qualitySum = 0; 
  var difficultySum = 0;
  var quantity = 0;

  var lecturesRef = await fireStore.collection(university).doc(department).collection(lecture).get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
      qualitySum = qualitySum + doc.data().quality
      difficultySum = difficultySum + doc.data().difficulty
      quantity = quantity + 1
    })
  })

  var qualityAvg = Math.round(qualitySum/quantity*100000)/100000;
  var difficultyAvg = Math.round(difficultySum/quantity*100000)/100000;

  var lectureRef = await fireStore.collection('univ_list').doc(university).collection('dep_list').doc(department).collection('lec_list').doc(lecture).update({
    quantity: quantity,
    qualityAvg: qualityAvg,
    difficultyAvg: difficultyAvg,
  }).then( () => {
    response.send('Successfully calculated');
  })
})

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
