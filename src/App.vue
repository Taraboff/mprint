<template>
  <div class="container">
    <div class="title">
      Отслеживание статуса заявки на заправку и ремонт картриджей
    </div>
    <div class="logo">
      <img class="imglogo" src="./assets/logo2.png" alt="logo" />
    </div>
  </div>

  <div class="contain">
    <vue-good-table
      ref="vgt"
      :columns="columns"
      :rows="tasks"
      :key="appKey"
      theme="polar-bear"
      :paginate="false"
      v-on:row-click="onRowClick"
      :sort-options="{
        enabled: true,
        multipleColumns: true,
        initialSortBy: [
          { field: 'workstatus', type: 'asc' },
          { field: 'id', type: 'asc' },
        ],
      }"
    />
  </div>
  <button v-show="isAdmin" class="btn-new" @click="addnew()">
    <i class="btn-new fa-solid fa-circle-plus"></i>
  </button>
  <div class="footer">
    <div class="date">Информация обновлена {{ updated }}</div>
    <div class="date">Версия{{ version }}</div>
  </div>

  <modal ref="modalEdit">
    <template v-slot:header>
      <h4>Редактирование заявки №{{ row.id }}</h4>
      <button class="btn-delete" @click="delTask()">
        <i class="fa-regular fa-trash-can"></i>
      </button>
    </template>

    <template v-slot:body>
      <label for="username">Пользователь:</label>
      <input name="username" v-model="this.row.username" />
      <label for="printer">Модель принтера:</label>
      <input name="printer" v-model="this.row.printer" />
      <label for="cartridge">Тип картриджа:</label>
      <input name="cartridge" v-model="this.row.cartridge" />
      <label for="location">Местонахождение принтера / МФУ:</label>
      <input name="location" v-model="this.row.location" />
      <label for="workstatus">Статус работы:</label>
      <input name="workstatus" v-model="this.row.workstatus" />
      <label for="datein">Дата приемки на заправку/ремонт:</label>
      <input name="datein" v-model="this.formatDateIn" type="date" size="15" />
      <label for="comment">Комментарий:</label>
      <input name="comment" v-model="this.row.comment" />
    </template>

    <template v-slot:footer>
      <div class="modal-footer">
        <button
          class="btn btn--secondary"
          @click="$refs.modalEdit.closeModal(true)"
        >
          Отмена
        </button>
        <button class="btn btn--primary" @click="saveTask()">Сохранить</button>
      </div>
    </template>
  </modal>
  <modal ref="modalNew">
    <template v-slot:header>
      <h4>Создание новой заявки</h4>
    </template>

    <template v-slot:body>
      <label for="username">Пользователь:</label>
      <input name="username" v-model="this.row.username" />
      <label for="printer">Модель принтера:</label>
      <input name="printer" v-model="this.row.printer" />
      <label for="cartridge">Тип картриджа:</label>
      <input name="cartridge" v-model="this.row.cartridge" />
      <label for="location">Местонахождение принтера / МФУ:</label>
      <input name="location" v-model="this.row.location" />
      <label for="workstatus">Статус работы:</label>
      <input name="workstatus" v-model="this.row.workstatus" />
      <label for="datein">Дата приемки на заправку/ремонт:</label>
      <input name="datein" v-model="this.formatDateIn" type="date" size="15" />
      <label for="comment">Комментарий:</label>
      <input name="comment" v-model="this.row.comment" />
    </template>

    <template v-slot:footer>
      <div class="modal-footer">
        <button
          class="btn btn--secondary"
          @click="$refs.modalNew.closeModal(true)"
        >
          Отмена
        </button>
        <button class="btn btn--primary" @click="saveTask()">Сохранить</button>
      </div>
    </template>
  </modal>
</template>

<script>
import { VueGoodTable } from "vue-good-table-next";
import "vue-good-table-next/dist/vue-good-table-next.css";
import Modal from "./components/Modal";
import { ref } from "vue";

const BACKEND_URL = "http://localhost:8182"; // If DEV
// const BACKEND_URL = "";  // If PRODUCTION

export default {
  components: {
    VueGoodTable,
    Modal,
  },

  name: "App",
  setup() {
    const row = ref({});
    return {
      row,
    };
  },
  data() {
    return {
      version: " 0.9.8 от 20.01.2022 г.",
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
          filterable: true,
          formatFn: this.viewDateFn,
        },
        {
          label: "Примечание",
          field: "comment",
          filterable: true,
        },
      ],
      appKey: 0,
      tasks: [],
      allowedIp: ["1", "192.168.1.251", "10.80.199.73", "10.80.199.29"],
      isAdmin: false,
      updated: "20.01.2022 13:15",
    };
  },
  methods: {
    async bdinit() {
      const response = await fetch(`${BACKEND_URL}/mprintinit`); //${BACKEND_URL}

      const result = await response.json();
      // console.log("result2: ", result2);
      this.tasks = result;
    },
    async getip() {
      let response = await fetch(`${BACKEND_URL}/getip`); //${${BACKEND_URL}}
      if (response.ok) {
        let result = await response.json();

        if (result) {
          console.log("result.ip: ", result.ip);
          this.isAdmin = this.allowedIp.includes(result.ip);
        }
      } else {
        console.log(`Ошибка init: ${response.status}`);
      }
    },
    parseDate(dt) {
      const date = new Date(dt);
      const year = date.getFullYear();
      const month =
        date.getMonth() < 9 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
      const day = date.getDate() < 9 ? "0" + date.getDate() : date.getDate();
      return { day: day, month: month, year: year };
    },

    viewDateFn(val) {
      const date = this.parseDate(val);
      return `${date.day}.${date.month}.${date.year}`;
    },
    addnew() {
      this.row = {
        id: "",
        username: "",
        printer: "",
        cartridge: "",
        location: "",
        workstatus: "",
        datein: new Date(),
        comment: "",
      };
      this.$refs.modalNew.openModal();
    },
    async delTask() {
      try {
        let resp = await fetch(`${BACKEND_URL}/mprintdelete/${this.row.id}`);
        if (resp.ok) {
          let result = await resp.json();
          console.log("result: ", result);
          this.$refs.modalEdit.closeModal(true);
          this.bdinit();
        }
      } catch (e) {
        console.log("Ошибка запроса /mprintdelete", e);
      }
    },
    async saveTask() {
      const fData = new FormData();
      fData.append("id", this.row.id);
      fData.append("username", this.row.username);
      fData.append("printer", this.row.printer);
      fData.append("cartridge", this.row.cartridge);
      fData.append("workstatus", this.row.workstatus);
      fData.append("location", this.row.location);
      fData.append("datein", this.formatDateIn);
      fData.append("comment", this.row.comment);

      try {
        let response = await fetch(`${BACKEND_URL}/mprintupdate`, {
          method: "POST",
          mode: "no-cors",
          headers: {
            "Content-Type": "form-data",
          },
          body: fData,
        });
        if (response.ok) {
          let data = await response.json();
          console.log("data: ", data);
        }
      } catch (e) {
        console.log("Ошибка запроса /mprintupdate", e);
      }

      this.$refs.modalEdit.closeModal(false);
      this.$refs.modalNew.closeModal(false);
      this.bdinit();
    },
    onRowClick(params) {
      this.row = params.row; //  row object - редактируемая запись
      // params.pageIndex - index of this row on the current page.
      // params.selected - if selection is enabled this argument
      // indicates selected or not
      // params.event - click event

      this.$refs.modalEdit.openModal();
    },
  },
  computed: {
    formatDateIn: {
      get() {
        const date = this.parseDate(this.row.datein);
        return `${date.year}-${date.month}-${date.day}`;
      },
      set(newdate) {
        this.row.datein = newdate;
      },
    },
  },
  async mounted() {
    this.bdinit(); // загрузка данные из БД
    this.getip();
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
  color: #6b6b6b;
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
  margin-top: 5px;
  text-align: center;
  font-size: 0.8em;
  color: #6b6b6b;
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
label {
  font-size: 0.8em;
  color: #6b6b6b;
  margin: 1.1em 0 0.5em;
}
input {
  border: none;
  border-bottom: 1px dotted rgb(255, 171, 138);
  margin: 0;
  padding: 0;
  display: block;
  outline: none;
  color: rgb(231, 45, 45);
  font-size: 1em;
}
input[type="date"] {
  font-family: Arial, Helvetica, sans-serif;
  width: 28%;
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
.btn-new {
  position: relative;
  left: 5%;
  top: 5px;
  font-size: 1.5em;
  color: #e74c3c;
  text-shadow: 1px 1px 2px rgb(179, 177, 177);
}
.btn-new:hover {
  color: #dd4f3f;
  text-shadow: 1px 1px 2px rgb(255, 255, 255);
}
.btn-delete {
  font-size: 1em;
  color: #6b6b6b;
}
.savebutton {
  position: fixed;
  left: 50px;
}
.saveicon {
  text-decoration: none;
  /* color: #667b94; */
  color: #6b6b6b;
  font-size: 1.1rem;
}
.saveicon:hover {
  color: #e74c3c;
}

.btn {
  padding: 8px 16px;
  border-radius: 5px;
}
.btn--primary {
  background-color: #e74c3c;
  color: #fff;
}
.btn--secondary {
  background-color: #dddd;
  color: #000;
}

/*  utilities */
.overflow-hidden {
  overflow: hidden;
}
.mx-auto {
  margin-left: auto;
  margin-right: auto;
}
.modal-footer {
  display: flex;
  align-items: center;
  justify-content: space-around;
}

/* // reset */
button {
  background: none;
  border: none;
  outline: inherit;
  cursor: pointer;
}

h1,
h2,
h3,
h4,
h5,
h6 {
  margin: 0;
}
.footer {
  margin-top: 40px;
}
</style>
