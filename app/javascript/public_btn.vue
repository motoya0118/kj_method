<template>
  <div v-model="public" v-if="!public" class="public-false" @click="public_change">公開する</div>
  <div v-else class="public-true" @click="public_change">非公開にする</div>
</template>
<script>
  export default {
    data(){return{
      public: window.store.public
    }},
    methods:{
      public_change: function(){
        var data = new FormData
        data.append("place[public]",!this.public)
          Rails.ajax({
          url: `/themas/${window.store.id}/places/${window.store.id}`,
          type: "PATCH",
          data: data,
          dataType: "json",
          }
        )
        this.public = !this.public
      }
    }
  }
</script>
<style>
  .public-false{
  height:50px;
  width:100px;
  text-align:center;
  padding:15px 0;
  background-color: gray;
  border-color: white;
  }
  .public-true{
  height:50px;
  width:100px;
  text-align:center;
  padding:15px 0;
  background-color: pink;
  border-color: white;
  }
</style>