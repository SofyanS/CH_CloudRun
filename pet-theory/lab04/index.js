const express = require('express');
const app = express();
const cors = require('cors');
const Firestore = require('@google-cloud/firestore');
const db = new Firestore();
app.use(cors({ origin: true }));

const port = process.env.PORT || 8080;

app.listen(port, () => {
  console.log('Pet Theory REST API listening on port', port);
});

app.get('/v1', async (req, res) => {
  res.json({status: 'running'});
});

app.get('/v1/customer/:id', async (req, res) => {
  const customerId = req.params.id;
  const customer = await getCustomer(customerId);
  if (customer) {
    res.json({status: 'success', data: await getAmounts(customer)});
  }
  else {
    res.status(404);
    res.json({status: 'fail', data: {title: `Customer "${customerId}" not found`}});
  }
});

async function getCustomer(id) {
  const queryRef = db.collection('customers').where('id', '==', id);
  const querySnapshot = await queryRef.get();
  let retVal;
  querySnapshot.forEach(docSnapshot => {
    retVal = docSnapshot.data();
  });
  return retVal;
}

async function getAmounts(customer) {
  const retVal = {proposed:0, approved:0, rejected:0};
  const collRef = db.collection(`customers/${customer.email}/treatments`);
  const querySnapshot = await collRef.get();
  querySnapshot.forEach(docSnapshot => {
    const treatment = docSnapshot.data();
    retVal[treatment.status] += treatment.cost;
  });
  return retVal;
}