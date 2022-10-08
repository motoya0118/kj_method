<template>
  <div class="explain" v-model="open" v-on:click="open=!open">説明
  <transition name="menu">
    <div class="menu" v-show="open" v-on:child-event="parentMethod">
      <div class="top btn btn-danger" v-on:click="click">x</div>
      <div class="menu__item h2">使い方</div>
      <div class="menu__item">ダブルクリックで削除可能 (同じ内容のカードを削除)</div>
      <div class="menu__item">ドラッグ&ドロップで移動可能(関連性の高いカードをグルーピングする)</div>
      <div class="menu__item">シングルクリックで内容修正可能(適切なグループ名に修正する)</div>
      <div class="menu__item">Navバーからドラック&ドロップすると要素を増やせる(足りない場合追加できる)</div>
      <div class="menu__item">Navバーから公開・非公開を切替可能(公開 = 外部から閲覧が可能な状態)</div>
      <iframe width="560" height="315" src="https://www.youtube.com/embed/anR6QVQtaCM?start=311" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
    </div>
  </transition>
  </div>
</template>
<script>
  export default {
    data(){return{
    open: false
    }
  },
  methods: {
    click: function(){//ボタンをクリックするとこのメソッドが起動する
        this.$emit('child-event');//親へイベント発火を伝える
    },
    parentMethod: function(){
      open=!open;
    }
  }
}
</script>
<style>
  .explain{
  height:50px;
  width:100px;
  text-align:center;
  padding:15px 0;
  background-color: yellow;
  border-color: white;
  }
  .menu{
  position: fixed;
  top: 0;
  right: 0;
  z-index: 1;
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #555;
  z-index:100;
}
.menu__item{
  width: 100%;
  height: auto;
  padding: .5em 1em;
  text-align: center;
  color: #fff;
  box-sizing: border-box;
}
.top{
  top:0;
  z-index:2;
}
iframe{
  margin-top: 5px;
}
</style>