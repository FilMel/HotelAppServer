const express = require("express");
const cors = require("cors");
const knex = require("knex").default;
const connection = knex({
  client: "mysql",
  connection: {
    host: "localhost",
    user: "root",
    password: "1234",
    database: "hotel",
  },
});

const app = express();

connection((res, err) => {
  if (err) {
    console.log(err);
  }
});

app.use(cors());
app.use(express.json());

app.post("/", async (req, res) => {
  const checkin = req.body.checkin;
  const checkout = req.body.checkout;
  const roomName = req.body.roomName;

  const toCompare = await connection("prenotazione").select(
    "CheckIn",
    "CheckOut",
    "camera_Nome"
  );
  let count = 0;
  if (toCompare.length !== 0) {
    for (const result in toCompare) {
      count =
        checkin < result.CheckIn &&
        checkout > result.CheckOut &&
        roomName === result.camera_Nome
          ? count + 1
          : count;
    }
  }
  res.json({ isAvailable: count === 0 });
});

app.post("/prenota", async (req, result) => {
  const checkin = req.body.checkin;
  const checkout = req.body.checkout;
  const roomName = req.body.roomName;

  const nome = req.body.visitor_name;
  const cognome = req.body.visitor_surname;
  const email = req.body.visitor_email;
  const telefono = req.body.visitor_phone;
  const NrPassaporto = req.body.passport;

  const nomei = req.body.IntF_name;
  const cognomei = req.body.IntF_surname;
  const indirizzo = req.body.adress;
  const citta = req.body.city;
  const cap = req.body.zip;

  console.log(cognome, telefono);

  //Needed to add await because the function is a promise.
  let price = await connection("camera")
    .where({ Nome: roomName })
    .select("Prezzo")
    .then((res) => {
      return res[0].Prezzo;
    });

  const today = new Date().toISOString().split("T")[0];

  const period =
    (new Date(checkout).getTime() - new Date(checkin).getTime()) /
    (1000 * 3600 * 24);
  const prezzoTot = period * price;

  const idIntest = await connection("intestatariofattura")
    .insert({
      Nome: nomei,
      Cognome: cognomei,
      Citta: citta,
      Indirizzo: indirizzo,
      CAP: cap,
    })
    .then((res) => {
      return res[0];
    });

  connection("cliente")
    .insert({
      Nome: nome,
      Cognome: cognome,
      Telefono: telefono,
      Email: email,
      NrPassaporto: NrPassaporto,
    })
    .then((res) => {
      connection("prenotazione")
        .insert({
          CheckIn: checkin,
          CheckOut: checkout,
          CodiceGenerato: "1234",
          cliente_idCliente: res[0],
          camera_Nome: roomName,
        })
        .then((res) => {
          connection("fattura")
            .insert({
              Data: today,
              ImportoTotale: prezzoTot,
              IntestatarioFattura_idIntestatarioFattura: idIntest,
              prenotazione_idPrenotazione: res[0],
            })
            .then((res, err) => {
              if (err) {
                console.log(err);
              } else result.json({ isInserted: true });
            });
        });
    });
});

app.listen(4000, () => {
  console.log(`App server listening on port 4000`);
});
