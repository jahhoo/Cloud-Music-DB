<script context="module">
  let globalLabels;

  export function setLabels(labels) {
    globalLabels = labels;
  }
</script>

<script>
  import { createEventDispatcher, getContext } from "svelte";

  const stateContext = getContext("state");
  const dispatch = createEventDispatcher();

  // function Filter
  export let filter = (row, text, index) => {
    for (let i in row) {
      if (
        row[i]
          .toString()
          .toLowerCase()
          .indexOf(text) > -1
      ) {
        return true;
      }
    }
    return false;
  };

  export let index = -1;
  export let text = "";

  export let labels = {
    placeholder: "Search",
    ...globalLabels
  };

  if (document.documentElement.lang == "cs") {
    labels = {
      placeholder: "Prohledat",
      ...globalLabels
    };
  }

  async function onSearch(event) {
    const state = stateContext.getState();
    const searchText = event.target.value.toLowerCase();

    const detail = {
      originalEvent: event,
      filter,
      index,
      text: searchText,
      page: state.page,
      pageIndex: state.pageIndex,
      pageSize: state.pageSize,
      rows: state.filteredRows
    };

    dispatch("search", detail);

    if (detail.preventDefault !== true) {
      if (detail.text.length === 0) {
        stateContext.setRows(state.rows);
      } else {
        const filteredRows = detail.rows.filter(r => detail.filter(r, detail.text, index));
        stateContext.setRows(filteredRows);
      }
      stateContext.setPage(0, 0);
    } else {
      stateContext.setRows(detail.rows);
    }
  }
</script>

<div class="search">
  <input
    type="search"
    title={labels.placeholder}
    placeholder={labels.placeholder}
    bind:value={text}
    on:keyup={onSearch} />
</div>


<style>
  .search {
    width: 23vw;
    max-width: 370px;
    float: right;
  }
  .search input {
    width: 100%;
    border: 2px solid #eee;
    border-radius: 3px;
    padding: 8px 6px;
  }

  @media screen and (max-width: 767px) {
    .search {
      width: 100%;
    }
  }
</style>
