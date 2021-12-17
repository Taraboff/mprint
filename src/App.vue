<template>
  <div class="container">
    <div class="title">Отслеживание статуса заявки на заправку и ремонт картриджей</div>
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
    />
  </div>

  <div class="date">Информация обновлена 03.11.2021 г. 09:50</div>
  <div class="date">Версия{{ version }}</div>

  <modal ref="modalName">
    <template v-slot:header>
      <h4>Редактирование заявки №{{ row.id }}</h4>
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
      <input name="datein" v-model="this.formatDateIn" type="date" size="15"/>
      <label for="comment">Комментарий:</label>
      <input name="comment" v-model="this.row.comment" />
    </template>

    <template v-slot:footer>
      <div
        class="modal-footer d-flex align-items-center justify-content-between"
      >
        <button
          class="btn btn--secondary"
          @click="$refs.modalName.closeModal(true)"   
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
      version: " 0.9.5 vfm от 17.12.2021 г.",
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
          // type: "date",
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
    };
  },
  methods: {
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
        // if (this.row.id === "+") fetch  /mprintnew
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
          console.log("data: ", data);
        }
      } catch (e) {
        console.log("Ошибка запроса /mprintupdate", e);
      }

      this.$refs.modalName.closeModal(false);
    },
    onRowClick(params) {
      this.$refs.modalName.openModal();

      this.row = params.row; //  row object
      // params.pageIndex - index of this row on the current page.
      // params.selected - if selection is enabled this argument
      // indicates selected or not
      // params.event - click event
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
  async created() {
    // data_url устанавливается в завистмости от среды разработки
    // const data_url = "http://192.168.1.252:8181/mprint/cart.json";
    const data_url = "http://localhost:8182/mprintinit"; // разработка на iPC
    const response = await fetch(data_url);
    const result = await response.json();
    this.tasks = result;
    this.tasks.push({ id: "+" });
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
label {
  font-size: 0.8em;
  color: #6b6b6b;
  margin: 0.9em 0 0.5em;
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
</style>
