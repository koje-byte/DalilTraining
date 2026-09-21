const students = [];
students.push({
name:'Sara',
score: 80
});

//
function getGrade(score)
{
if(score >= 90)
return "Excellent";
else if (score >=75)
return "Good"
else
return "Needs improvement"
}

const nameInput = document.getElementById("nameInput");
const scoreInput = document.getElementById("scoreInput");
const addBtn = document.getElementById("addBtn");
const tbody=document.getElementById("tbody");
//
addBtn.addEventListener("click" , function(){
//Get Values
const name = nameInput.value ;
const score =Number(scoreInput.value);
if(name=="")
{
    alert("name cannot be Empty");
    return;
}
if(score=="")
{
    alert("score cannot be Empty");
    return;
}

if(score>100)
{
    alert("score cannot exceed 100");
    return;
}

if(score<0)
{
    alert("score cannot be below 0");
    return;
}

students.push({
name : name,
score: score
})

//
render();
})

function render(){
tbody.innerHTML="";

   for(let i=0; i<students.length;i++)
  {
    const std = students[i];
    //create row

    const tr= document.createElement("tr") ;
    const tdName = document.createElement("td");
    tdName.textContent= std.name;

    const tdScore = document.createElement("td");
    tdScore.textContent= std.score;

    const tdGrade = document.createElement("td");
    tdGrade.textContent= getGrade(std.score);

    const tdRemove=document.createElement("td");
    const tdRemoveButton=document.createElement("button");
    tdRemoveButton.textContent="Remove"
    tdRemoveButton.addEventListener("click", function() { students.splice(i, 1); render(); });
    tdRemove.appendChild(tdRemoveButton)
    tr.appendChild(tdName);
    tr.appendChild(tdScore);
    tr.appendChild(tdGrade);
    tr.append(tdRemove)
    tbody.appendChild(tr);
  }
}

render();

const clearAll=document.getElementById("clearBtn");
clearAll.addEventListener("click",function(){
if (students.length==0)
    alert("there are 0 students Already");
students.length=0;
render();
});

const searchInput = document.getElementById("searchInput");
searchInput.addEventListener("input", function() {

    const searchText = searchInput.value.toLowerCase();

    tbody.innerHTML = "";

    for (let i = 0; i < students.length; i++) {

        const student = students[i];

        if (student.name.toLowerCase().includes(searchText)) {

            const tr = document.createElement("tr");

            const tdName = document.createElement("td");
            tdName.textContent = student.name;

            const tdScore = document.createElement("td");
            tdScore.textContent = student.score;

            const tdGrade = document.createElement("td");
            tdGrade.textContent = getGrade(student.score);

            tr.appendChild(tdName);
            tr.appendChild(tdScore);
            tr.appendChild(tdGrade);

            tbody.appendChild(tr);
        }
    }
});