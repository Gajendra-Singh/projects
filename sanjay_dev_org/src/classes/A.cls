public class A {
      
    private A()
    {
        //sanjay  a3logicaabbbb
    }

    public static A create()
    {
        return new A();
    }
    
    public void add()
    {
        System.debug('I Have Got Private Constructor Instance');
    }
}