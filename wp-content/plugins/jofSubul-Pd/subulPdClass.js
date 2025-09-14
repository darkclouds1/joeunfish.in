class subulPdClass {
  constructor() {
    this.data = [];
    this.table1 = null; // 테이블 DOM 요소를 저장할 프로퍼티
    this.platForm = 'computer'; // 기본값 설정
  }

  // 데스크톱용 테이블 헤더 생성
  makeTableHead() {
    this.table1 = document.createElement("table");
    this.table1.id = "pd-table";
    this.table1.classList.add("subul-pd-table"); // 클래스 추가

    if (this.table1.querySelector('thead')) {
      return;
    }

    const header = this.table1.createTHead();
    const tr = header.insertRow(-1);

    // 데이터에서 날짜 키를 동적으로 추출하고 정렬
    const dates = Object.keys(this.data[0]).filter(key => key !== '구분' && key !== '합계').sort();
    
    // ISO 8601 표준에 따른 연간 주차 계산 함수
    const getWeekNumber = (d) => {
        // 날짜 객체를 복사하여 원본을 수정하지 않도록 함
        d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
        // 주의 목요일을 기준으로 주차를 계산함 (ISO 8601 표준)
        // 일요일(0)을 7로 처리하여 계산을 용이하게 함
        const dayNum = d.getUTCDay() || 7;
        d.setUTCDate(d.getUTCDate() + 4 - dayNum);
        // 연초(1월 1일)를 기준으로 몇 주가 지났는지 계산
        const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
        return Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
    };

    // 열 순서: 비고 (주차 정보), 날짜들, 합계
    const th_remarks = document.createElement("th");
    if (dates.length > 0) {
        const firstDate = new Date(dates[0]); // dates[0]은 항상 일요일
        
        // 월요일을 기준으로 주차를 계산하기 위해 날짜를 하루 뒤로 설정
        const mondayDate = new Date(firstDate);
        mondayDate.setUTCDate(mondayDate.getUTCDate() + 1);

        const month = mondayDate.getUTCMonth() + 1; // 월요일이 속한 월
        const weekNumber = getWeekNumber(mondayDate); // 월요일 기준 주차
        th_remarks.textContent = `${month}월 ${weekNumber}주차`;
    } else {
        th_remarks.textContent = "비고";
    }
    tr.appendChild(th_remarks);

    const days = ['일', '월', '화', '수', '목', '금', '토'];

    dates.forEach(dateStr => {
        const th = document.createElement("th");
        const date = new Date(dateStr);
        // UTC 기준으로 날짜를 계산하여 시간대 문제 방지
        const month = date.getUTCMonth() + 1;
        const day = date.getUTCDate();
        const dayOfWeek = days[date.getUTCDay()];
        th.textContent = `${month}/${day}(${dayOfWeek})`;
        tr.appendChild(th);
    });
    
    const th_total = document.createElement("th");
    th_total.textContent = "합계";
    tr.appendChild(th_total);
  }

  // 데스크톱용 테이블 바디 생성
  makeTableBody(datas) {
    if (!datas || datas.length === 0) {
      return 0;
    }

    const tbody = this.table1.createTBody();
    const dates = Object.keys(datas[0]).filter(key => key !== '구분' && key !== '합계').sort();

    datas.forEach(rowData => {
      const row = tbody.insertRow();
      
      // 1. 비고 (구분)
      const cellGuBun = row.insertCell();
      cellGuBun.textContent = rowData['구분'];

      // 2. 날짜별 데이터
      dates.forEach(date => {
        const cell = row.insertCell();
        const value = rowData[date];
        cell.textContent = value ? Number(value).toLocaleString() : '0';
        cell.style.textAlign = 'right';
      });

      // 3. 합계
      const cellTotal = row.insertCell();
      cellTotal.textContent = rowData['합계'] ? Number(rowData['합계']).toLocaleString() : '0';
      cellTotal.style.textAlign = 'right';
    });

    const divContainer = document.getElementById("tables-pd");
    divContainer.innerHTML = ""; // 이전 내용 초기화
    divContainer.appendChild(this.table1);

    return datas.length;
  }

  // 모바일용 카드 뷰 생성
  makeTableMobile(datas) {
    const container = document.getElementById("tables-pd");
    container.innerHTML = "";

    if (!datas || datas.length === 0) {
      container.innerHTML = "<div class='no-data-message'>데이터가 없습니다</div>";
      return;
    }

    const dates = Object.keys(datas[0]).filter(key => key !== '구분' && key !== '합계').sort();
    const days = ['일', '월', '화', '수', '목', '금', '토'];

    datas.forEach(item => {
      const card = document.createElement('div');
      card.className = 'mobile-card collapsed'; // 기본적으로 접힌 상태

      const header = document.createElement('div');
      header.className = 'card-header';
      header.innerHTML = `
        <div class="header-main">
          ${item['구분']}
          <span class="header-total">합계: ${Number(item['합계']).toLocaleString()}</span>
        </div>
        <span class="click-indicator"><span class="arrow">▼</span></span>
      `;
      card.appendChild(header);

      const content = document.createElement('div');
      content.className = 'card-content';
      content.style.display = 'none';

      dates.forEach(dateStr => {
        const value = Number(item[dateStr] || 0);
        if (value !== 0) { // 값이 0이 아닌 경우에만 표시
          const date = new Date(dateStr);
          const month = date.getUTCMonth() + 1;
          const day = date.getUTCDate();
          const dayOfWeek = days[date.getUTCDay()];
          const formattedDate = `${month}/${day}(${dayOfWeek})`;

          const dataItem = document.createElement('div');
          dataItem.className = 'data-item';
          dataItem.innerHTML = `<span class="data-label">${formattedDate}:</span> <span class="data-value">${value.toLocaleString()}</span>`;
          content.appendChild(dataItem);
        }
      });

      card.appendChild(content);
      container.appendChild(card);

      // 카드 헤더 클릭 시 내용 토글
      header.addEventListener('click', () => {
        card.classList.toggle('collapsed');
        const isCollapsed = card.classList.contains('collapsed');
        content.style.display = isCollapsed ? 'none' : 'block';
        header.querySelector('.arrow').textContent = isCollapsed ? '▼' : '▲';
      });
    });
  }

  // 서버에서 데이터 로드
  loadData() {
    const from_date = document.getElementById("fromDate-pd").value;
    const to_date = document.getElementById("toDate-pd").value;

    if (!from_date || !to_date) {
      alert("시작일과 종료일을 모두 선택해주세요.");
      return;
    }

    setTimeout(() => move(), 100);

    const param = `from_date=${from_date}&to_date=${to_date}`;
    const url = `${subul_pd_srv}?category=search_pd&${param}`;

    const tableContainer = document.getElementById("tables-pd");
    tableContainer.innerHTML = "";

    fetch(url)
      .then(response => {
        if (!response.ok) throw new Error("네트워크 응답이 실패했습니다.");
        return response.json();
      })
      .then(result => {
        if (result.status === 'success') {
          this.data = result.data;
          tableContainer.innerHTML = "";

          const hasData = this.data && this.data.length > 0;

          if (this.platForm === "computer") {
            if (hasData) {
              this.makeTableHead();
              this.makeTableBody(this.data);
            } else {
              tableContainer.innerHTML = "<div class='no-data-message'>데이터가 없습니다</div>";
            }
          } else { // mobile
            if (hasData) {
              this.makeTableMobile(this.data);
            } else {
              tableContainer.innerHTML = "<div class='no-data-message'>데이터가 없습니다</div>";
            }
          }
        } else {
          throw new Error(result.message || "데이터 로드 실패");
        }
      })
      .catch(error => {
        console.error("데이터 로드 중 오류 발생:", error);
        tableContainer.innerHTML = `<div class='no-data-message'>오류: ${error.message}</div>`;
      })
      .finally(() => {
        move_stop();
      });
  }
}

// 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', () => {
  if (typeof window.subulPd === 'undefined') {
    window.subulPd = new subulPdClass();
  }

  // platForm 설정
  if (window.matchMedia("only screen and (max-width: 760px)").matches) {
    subulPd.platForm = 'mobile';
  } else {
    subulPd.platForm = 'computer';
  }
  
  // 조회 버튼 이벤트
  const searchBtn = document.getElementById('searchBtn-pd');
  if (searchBtn) {
    searchBtn.addEventListener('click', () => subulPd.loadData());
  }

  // --- 날짜 관련 이벤트 리스너 설정 ---
  const fromDateEl = document.getElementById('fromDate-pd');
  const toDateEl = document.getElementById('toDate-pd');

  if (fromDateEl && toDateEl) {
    const adjustDatesAndReload = () => {
      const fromDateValue = fromDateEl.value;
      if (!fromDateValue) return;

      // 1. 선택한 날짜를 Date 객체로 변환 (시간대 문제 방지)
      const parts = fromDateValue.split('-');
      const year = parseInt(parts[0], 10);
      const month = parseInt(parts[1], 10) - 1; // JS 월은 0부터 시작
      const day = parseInt(parts[2], 10);
      const selectedDate = new Date(year, month, day);

      // 2. 선택한 날짜가 속한 주의 일요일로 날짜 조정
      const dayOfWeek = selectedDate.getDay(); // 0=일요일, 1=월요일, ...
      selectedDate.setDate(selectedDate.getDate() - dayOfWeek);

      // 3. fromDate 입력 필드 업데이트
      const fromYear = selectedDate.getFullYear();
      const fromMonth = String(selectedDate.getMonth() + 1).padStart(2, '0');
      const fromDay = String(selectedDate.getDate()).padStart(2, '0');
      fromDateEl.value = `${fromYear}-${fromMonth}-${fromDay}`;
      
      // 4. fromDate에 10일을 더해 toDate 계산 및 업데이트
      const toDate = new Date(selectedDate);
      toDate.setDate(toDate.getDate() + 10);
      const toYear = toDate.getFullYear();
      const toMonth = String(toDate.getMonth() + 1).padStart(2, '0');
      const toDay = String(toDate.getDate()).padStart(2, '0');
      toDateEl.value = `${toYear}-${toMonth}-${toDay}`;

      // 5. 변경된 날짜로 데이터 다시 로드
      subulPd.loadData();
    };

    fromDateEl.addEventListener('change', adjustDatesAndReload);

    fromDateEl.addEventListener('keypress', (event) => {
      if (event.key === 'Enter') {
        event.preventDefault();
        searchBtn.click();
      }
    });
  }
  // --- 날짜 관련 이벤트 리스너 설정 끝 ---

  // 페이지 로드 시 데이터 조회
  setTimeout(() => {
    subulPd.loadData();
  }, 100);
});