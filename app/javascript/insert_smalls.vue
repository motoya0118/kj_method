<template>
  <draggable v-model="smalls" :options="smallsOption" class="smalls">
    <div v-for="small in smalls">{{small.name}}</div>
  </draggable>
</template>
<script>
import draggable from 'vuedraggable'

export default {
  components: {draggable},
  data(){return{
    smalls:[{name:'SmallGroup',flag:true,cards:[{name:'card'}]}],
    smallsOption:{
        group:{
          name: "smalls",
          pull: "clone",
          put: false,
        },
      sort: false
    }
  }}
}
</script>
<style>
 .smalls{
  height:50px;
  width:100px;
  text-align:center;
  padding:15px 0;
  background-color: rgb(0, 166, 255);
  border-color: white;
  cursor: grab;
 }

</style>