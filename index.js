const express = require("express");
const cors = require("cors");
const mysql = require("mysql");

const app = express();

/*const checkin = req.body.checkin
const checkout = req.body.checkout
const tipologia = req.body.roomType*/

const SELECT_NOTAVAILABLE_ROOMS =
  "SELECT camera.Nome FROM prenotazione,camera WHERE CheckIn < ? AND CheckOut > ? AND Tipo = ? ";

const SELECT_ALL_ROOMS = "SELECT * FROM prenotazione,camera";

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "1234",
  database: "hotel",
});

connection.connect((err) => {
  if (err) {
    return err;
  }
});

//connection.query(SELECT_NOTAVAILABLE_ROOMS,[checkin,checkout,tipologia],(error, result) => { console.log.result});

connection.connect((err) => {
  if (err) {
    return err;
  }
});

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("vai a /prenotazioni per vedere le prenotazioni ");
});

app.get("/prenotazioni", (req, res) => {
  connection.query(SELECT_ALL_ROOMS, (err, results) => {
    if (err) {
      return console.log(err);
    } else {
      return res.json(results);
    }
  });
});

const SUBMIT_CLIENT_DATA =
  "INSERT INTO cliente (Nome, Cognome, Telefono, Email, NrPassaporto) VALUES (?,?,?,?,?)";

const SUBMIT_BOOKING_DATA =
  "INSERT INTO prenotazione (CheckIn, CheckOut, CodiceGenerato, cliente_idCliente, camera_Nome ) VALUES (?,?,?,(SELECT LAST_INSERT_ID()),?)";

const SUBMIT_INTESTATARIO_DATA =
  "INSERT INTO intestatarioFattura (Nome, Cognome, Citta, Indirizzo, CAP) VALUES (?,?,?,?,?)";

const SUBMIT_FATTURA_DATA =
  "INSERT INTO fattura (Data, ImportoTotale, IntestatarioFattura_idIntestatarioFattura, prenotazione_idPrenotazione) VALUES (?,?,(SELECT LAST_INSERT_ID()),(SELECT idPrenotazione FROM prenotazione WHERE (CheckIn = checkin AND CheckOut = checkout AND camera_Nome = roomName)))";

const querries = [
  SUBMIT_CLIENT_DATA,
  SUBMIT_BOOKING_DATA,
  SUBMIT_INTESTATARIO_DATA,
  SUBMIT_FATTURA_DATA,
];

app.post("/prenotazioni/prenota", (req, res) => {
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
  let price;

  connection.query(
    "SELECT Prezzo FROM camera WHERE Nome = ?",
    [roomName],
    (err, rows) => {
      if (err) throw err;
      setValue(rows[0].Prezzo);
    }
  );

  async function setValue(value) {
    await 1;
    price = value;
    console.log(price);
  }


  const today = new Date().toISOString().split("T")[0];
  console.log("today is " + today);

  const period =
    (new Date(checkout).getTime() - new Date(checkin).getTime()) /
    (1000 * 3600 * 24);
  console.log("check in is " + checkin + " checkout is " + checkout);
  console.log("period is " + period);
  console.log("price is " + price);
  const prezzoTot = period * price;
  console.log("Prezzo tot is " + prezzoTot);

  const values = [
    [nome, cognome, telefono, email, NrPassaporto],
    [checkin, checkout, "1234", roomName],
    [nomei, cognomei, citta, indirizzo, cap],
    [today, prezzoTot],
  ];

  for (let i = 0; i < 4; i++) {
    connection.query(querries[i], values[i], (err, result) => {
      if (err) {
        console.log(i + " " + err);
      } else {
        console.log(i + " Values Inserted " + result.insertId);
      }
    });
  }
  connection.query();
});

app.listen(4000, () => {
  console.log(`App server listening on port 4000`);
});
