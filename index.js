const express = require("express");
const cors = require("cors");
const mysql = require("mysql");
const app = express();

const SELECT_ALL_PRODUCTS_QUERY = 'SELECT * FROM camera';

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

app.use(cors());

app.get("/", (req, res) => {
  res.send("go to /camere to see camere ");
});

app.get("/camere", (req,res) => {
    connection.query(SELECT_ALL_PRODUCTS_QUERY, (err, results) => {
        if (err) {
          return console.log(err);
          
        } else {
          return res.json({ data: results });
        }
      });
});

app.listen(4000, () => {
  console.log(`App server listening on port 4000`);
});
