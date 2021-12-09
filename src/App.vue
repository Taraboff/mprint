<template>
  <div class="container">
    <div class="title">Отслеживание статуса заправки и ремонта картриджей</div>
    <div class="logo">
      <img class="imglogo" src="./assets/logo2.png" alt="logo" />
    </div>
  </div>
  <div
    class="savebutton"
    :style="{ left: btnX, top: btnY + 'px' }"
    v-if="showSaveButton"
    @click="saveTask"
  >
    <button>сохр</button>
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
      version: " 0.6.3 my от 09.12.2021 г.",
      columns: [
        {
          label: "№ заявки",
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
          filterable: true,
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
      editedRowObject: "",
      showSaveButton: false,
      btnX: "4px",
      btnY: 0,
    };
  },
  methods: {
    saveTask() {
      // перебор всех inputs в строке таблицы и сохранение элемента в массив tasks
      this.editmode = false;
      console.log("Сохранение записи...");
      // console.log(this.row.cartridge);
      this.appKey++;
    },
    onRowClick(params) {
      // params.row - row object
      this.row = params.row;
      // params.pageIndex - index of this row on the current page.
      // params.selected - if selection is enabled this argument
      // indicates selected or not
      // params.event - click event

      let currentRow = params.event.target.closest("tr");

      if (this.editmode) {
        console.log("Edit mode on");
      } else {
        this.btnX = params.event.clientX;
        this.btnY = params.event.clientY + 8;
        this.showSaveButton = true;
        this.editmode = true;
        // перед первым столбцом добавляется кнопка "Сохранить"
        currentRow.cells[0].innerHTML = params.row.id;

        for (let i = 1; i <= 7; i++) {
          let textInput = document.createElement("textarea");
          // textInput.type = "text";
          textInput.size = "30";
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
    const data_url = "http://localhost:8181/mprintinit"; // разработка на iPC
    // const data_url = "http://localhost/mprint/cart.json";  // разработка at home
    const response = await fetch(data_url);
    const data = await response.json();

    this.tasks = data;
  },
};
</script>

<style>
body {
  font-family: Arial, Helvetica, sans-serif;
}
.logo {
  /* width: 100%; */
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
}
</style>
