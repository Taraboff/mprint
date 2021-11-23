const cmd = document.querySelectorAll(".edit");
const saveBtns = document.querySelectorAll("tr");
let currentRow, recordsCount, jobs;

document.addEventListener("DOMContentLoaded", async function(event) { 

  const data = await fetch('cart.json');
  jobs = await data.json();
  recordsCount = jobs.mprint.length;

  // localStorage.setItem('mprint', JSON.stringify(json.mprint));
});

async function saveFile() {
  // let jobs = localStorage.getItem('mprint');
  let obj = {};
  obj.mprint = jobs.mprint;
  obj.saved = 'true';

  try {
    let response = await fetch('save.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify(obj)
    });

    if (!response.ok) {
        throw new Error('Ошибка ответа сервера');
    }
    let result = await response.json();

    return result;

} catch (error) {
    console.log('Возникла проблема с вашим fetch запросом: ', error.message);
}
}

[...cmd].forEach((element) => {
  element.addEventListener("click", (e) => {
    e.stopPropagation();
    const row = e.target.closest("tr");
    currentRow = row.dataset.id;
    // Перебор всех ячеек строки
    [...row.cells].forEach((td) => {
      if (td.classList.contains("commands")) {
        td.innerHTML = '<a href="#"><img class="save" src="assets/save.png"></a>';
      } else {
        let textInput = document.createElement("input");
        textInput.value = td.textContent;
        td.innerHTML = "";
        td.appendChild(textInput);
      }
    });

    [...cmd].forEach((element) => {
      element.classList.add("hide");
    });
  });
});

[...saveBtns].forEach(btn => {
  btn.addEventListener('click', (e) => {
    const id = e.target.closest('td').dataset.id;
    if (id === currentRow) {
      console.log(`Сохранение записи: ${id}`);
      const res = saveFile();
      console.log(res);

      const row = e.target.closest("tr");
      [...row.cells].forEach((td) => {
        if (!td.classList.contains("commands")) {
          td.innerHTML = td.children[0].value;
        } else {
          td.innerHTML = '<a href="#"><img class="edit" src="assets/edit.svg"></a>';
        }
      });

      // проход по всем rows и установка edit icons
      location.reload();
    }
  });
});
