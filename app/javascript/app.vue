<template>
  <!-- <draggable v-model="bigs" :options='bigoption' @end="listMoved">
    <div v-for="big in bigs">{{big.name}}</div>
  </draggable> -->
  <draggable v-model="lists" :options="largeOption" class="board dragArea" @end="listMoved" @change="Added">
    <list v-for="(list, index) in lists" :list="list" @delete="deleteBig(index,list.id)"><div class="small"></div></list>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'
import list from './components/list'

export default {
  components: { draggable, list },

  props:["original_lists"],

  data() {return{
      lists: this.original_lists,
      largeOption:{
        group: 'lists',
        disabled: window.store.disabled
      },
    }
  },
  methods: {
    listMoved: function(event) {
      var data = new FormData
      data.append("place[position]", event.newIndex + 1)
      Rails.ajax({
        url: `/large_groups/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
    },
    deleteBig: function(index_big,id){
      this.lists.splice(index_big,1)
      Rails.ajax({
        url: `/large_groups/${id}`,
        type: "DELETE",
        dataType: "json",
      })
    },
    Added: function(event){
      if (event.added){
        var data = new FormData
        data.append("place[position]", event.added.newIndex + 1)
        data.append("place[name]", this.lists[event.added.newIndex].name)
        data.append("place[place_id]", window.store.id)
        this.lists[event.added.newIndex].small_groups.splice(0,1)
        Rails.ajax({
          url: `/large_groups`,
          type: "POST",
          data: data,
          dataType: "json",
      })
      }
    }
  }
}
</script>

<style scoped>
.board{
  overflow-x: auto;
  white-space: nowrap;
  width: 1280px;
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
}


</style>
