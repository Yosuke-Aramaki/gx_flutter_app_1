const functions = require('firebase-functions')
// cloud functionでfirestoreを使うのに必要な設定は以下の２行
const admin = require('firebase-admin')
admin.initializeApp(functions.config().firebase)

// データベースの参照を作成
var fireStore = admin.firestore()

exports.calucrateAvg = functions.https.onRequest(async (request, response) => {
  var univ = request.query.univ;
  var dep = request.query.dep;
  var lec = request.query.lec;
  var qualitySum = 0; 
  var difficultySum = 0;
  var quantity = 0;

  var lecturesRef = await fireStore.collection(univ).doc(dep).collection(lec).get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
      qualitySum = qualitySum + doc.data().quality
      difficultySum = difficultySum + doc.data().difficulty
      quantity = quantity + 1
    })
  })

  var qualityAvg = Math.round(qualitySum/quantity*100000)/100000;
  var difficultyAvg = Math.round(difficultySum/quantity*100000)/100000;

  var lectureRef = await fireStore.collection('univ_list').doc(univ).collection('dep_list').doc(dep).collection('lec_list').doc(lec).update({
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
