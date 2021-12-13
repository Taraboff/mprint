<template>
  <div class="container">
    <div class="title">Отслеживание статуса заправки и ремонта картриджей</div>
    <div class="logo">
      <img class="imglogo" src="./assets/logo2.png" alt="logo" />
    </div>
  </div>
  <div
    class="savebutton"
    :style="{ top: btnY + 'px' }"
    v-if="showSaveButton"
    @click="saveTask"
  >
    <a href="" class="saveicon far fa-save"></a>
  </div>
  <div class="contain">
    <vue-good-table
      :columns="columns"
      :rows="tasks"
      :key="appKey"
      theme="polar-bear"
      :paginate="false"
      v-on:row-click="onRowClick"
      v-on:keyup.enter="saveTask"
    />
  </div>

  <div class="date">Информация обновлена 03.11.2021 г. 09:50</div>
  <div class="date">Версия{{ version }}</div>
</template>

<script>
import { VueGoodTable } from "vue-good-table-next";
import "vue-good-table-next/dist/vue-good-table-next.css";

export default {
  components: {
    VueGoodTable,
  },
  name: "App",
  data() {
    return {
      version: " 0.8 fdb от 13.12.2021 г.",
      columns: [
        {
          label: "№",
          field: "id",
        },
        {
          label: "Пользователь",
          field: "username",
        },
        {
          label: "Модель принтера",
          field: "printer",
          filterable: true,
        },
        {
          label: "Тип картриджа",
          field: "cartridge",
          filterable: true,
        },
        {
          label: "Статус",
          field: "workstatus",
          filterable: true,
        },
        {
          label: "Местонахождение",
          field: "location",
          filterable: true,
        },
        {
          label: "Дата",
          field: "datein",
          type: "date",
          filterable: true,
          formatFn: this.formatDate,
        },
        {
          label: "Примечание",
          field: "comment",
          filterable: true,
        },
      ],
      appKey: 0,
      tasks: [],
      counts: "",
      editmode: false,
      row: {},
      showSaveButton: false,
      btnY: 0,
      inputs: [],
    };
  },
  methods: {
    formatDate(val) {
      const date = new Date(val);
      const year = date.getFullYear();
      const month =
        date.getMonth() < 9 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
      const day = date.getDate() < 9 ? "0" + date.getDate() : date.getDate();
      return `${day}.${month}.${year}`;
    },
    async saveTask() {
      this.editmode = false;
      const fData = new FormData();
      fData.append("id", this.row.id);
      fData.append("username", this.inputs[0].value);
      fData.append("printer", this.inputs[1].printer);
      fData.append("cartridge", this.inputs[2].cartridge);
      fData.append("workstatus", this.inputs[3].workstatus);
      fData.append("location", this.inputs[4].location);
      fData.append("datein", this.inputs[5].datein);
      fData.append("comment", this.inputs[6].comment);

      try {
        let response = await fetch(`http://localhost:8182/mprintupdate`, {
          method: "POST",
          mode: "no-cors",
          headers: {
            "Content-Type": "form-data",
          },
          body: fData,
        });
        if (response.ok) {
          let data = await response.json();
          console.log("data: ", data.bd);
        }
      } catch (e) {
        console.log("Ошибка запроса /mprintupdate", e);
      }

      this.showSaveButton = false;
      // this.appKey++;
    },
    onRowClick(params) {
      this.row = params.row; //  row object
      // params.pageIndex - index of this row on the current page.
      // params.selected - if selection is enabled this argument
      // indicates selected or not
      // params.event - click event

      let currentRow = params.event.target.closest("tr");

      if (this.editmode) {
        console.log("Already in edit mode");
      } else {
        this.btnY = params.event.clientY;
        this.showSaveButton = true; // перед первым столбцом добавляется кнопка "Сохранить"
        this.editmode = true;

        currentRow.cells[0].innerHTML = params.row.id;

        for (let i = 1; i <= 7; i++) {
          let textInput = document.createElement("textarea");
          textInput.size = "30";
          textInput.id = this.columns[i].field;
          textInput.name = this.columns[i].field;
          textInput.value = currentRow.cells[i].textContent;
          currentRow.cells[i].innerHTML = "";
          currentRow.cells[i].append(textInput);
        }
      }
      this.inputs = [...document.querySelectorAll("textarea")];
    },
  },
  async created() {
    // data_url устанавливается в завистмости от среды разработки
    // const data_url = "http://192.168.1.252:8181/mprint/cart.json";
    const data_url = "http://localhost:8182/mprintinit"; // разработка на iPC
    const response = await fetch(data_url);
    const result = await response.json();
    this.tasks = result;
  },
};
</script>

<style>
body {
  font-family: Arial, Helvetica, sans-serif;
}
.logo {
  text-align: center;
  margin: 50px 0;
}
.logo img.imglogo {
  width: 80px;
  height: 80px;
  margin: auto;
}
.edit {
  width: 13px;
  height: 13px;
  margin-left: 4px;
  padding-right: 7px;
  display: block;
}
.save {
  width: 20px;
  height: 20px;
  padding-right: 7px;
  display: block;
}
.hide {
  display: none;
}
.container,
.contain {
  width: 90%;
  margin: auto;
}
.title {
  margin-top: 40px;
  font-size: 1.2em;
  font-weight: 700;
  text-align: center;
}
.status-table {
  display: flex;
  flex-direction: column;
}
.row {
  height: 20px;
  align-items: center;
  text-align: center;
  font-size: 1.1em;
  margin-bottom: 5px;
}
.inprocess {
  color: mediumvioletred;
}
.ready {
  color: mediumseagreen;
}
.waiting {
  color: black;
}
.done {
  color: rgb(34, 175, 53);
}
.date {
  margin-top: 50px;
  text-align: center;
  font-size: 0.9em;
}
.table {
  width: 96%;
  margin: auto;
  margin-bottom: 20px;
  border-collapse: collapse;
}
.table th {
  font-weight: bold;
  padding: 5px 15px;
  background: #c7fcef;
  border: 1px solid #dddddd;
  border-left: none;
  border-right: none;
  text-align: left;
}
.table td {
  font-size: 0.9em;
  border: 1px solid #dddddd;
  padding: 5px 15px;
  border-left: none;
  border-right: none;
}
.table tr td:first-child,
.table tr th:first-child {
  border-left: none;
}
.table tr td:last-child,
.table tr th:last-child {
  border-right: none;
}
/* Remove outline on the forms and links */
:active,
:hover,
:focus {
  outline: 0;
  outline-offset: 0;
}
input {
  border: none;
  border-bottom: 1px solid rgb(255, 171, 138);
  margin: 0;
  padding: 0;
  display: block;
  outline: none;
  color: rgb(231, 45, 45);
  font-size: 1em;
}
textarea {
  border: none;
  margin: 0;
  padding: 0;
  display: block;
  /* отключаем изменение размера мышью в Firefox */
  resize: none;

  /* удаляем обводку при фокусировке в Chrome */
  outline: none;
  position: relative;
  padding: 0;
  font-family: Arial, Helvetica, sans-serif;
  color: rgb(231, 45, 45);
  font-size: 1em;
}
.savebutton {
  position: fixed;
  left: 50px;
}
/* .btn {
  box-sizing: border-box;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background-color: transparent;
  border: 1px solid #e74c3c;
  border-radius: 1px;
  color: #e74c3c;
  cursor: pointer;
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  -webkit-align-self: center;
  -ms-flex-item-align: center;
  align-self: center;
  font-size: 1rem;
  font-weight: 400;
  line-height: 1;
  margin: 0px;
  padding: 0.4em 0.8em 0.4em;
  text-decoration: none;
  text-align: center;
  text-transform: uppercase;
  font-family: "Montserrat", sans-serif;
  /* font-weight: 700; */
/* } */
/* .btn:hover,
.btn:focus {
  color: #fff;
  outline: 0;
}

.btn {
  -webkit-transition: box-shadow 300ms ease-in-out, color 300ms ease-in-out;
  transition: box-shadow 300ms ease-in-out, color 300ms ease-in-out;
}
.btn:hover {
  box-shadow: 0 0 40px 40px #e74c3c inset;
} */
.saveicon {
  text-decoration: none;
  /* color: #667b94; */
  color: #6b6b6b;
  font-size: 1.1rem;
}
.saveicon:hover {
  color: #e74c3c;
}
</style>
