using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VGShootingManager : MonoBehaviour
{
    [SerializeField] private GameObject[] target;
    [SerializeField] private GameObject central;
    [SerializeField] private GameObject[] mask;
    [SerializeField] private Material blur;
    [SerializeField] private Aim aim;

    private StencilEffect[] effect = new StencilEffect[2];
    private enum State
    {
        shooting, black
    }
    private State state;
    private int maskCnt;

    void Start()
    {
        effect[0] = Camera.main.GetComponent<StencilEffect>();
        effect[1] = Camera.main.GetComponent<StencilEffectSecond>();
        maskCnt = 0;
        if (effect[0].material == blur)
        {
            state = State.shooting;
            mask[maskCnt].SetActive(true);
            central.SetActive(false);
        }
        else
        {
            state = State.black;
            mask[maskCnt].SetActive(false);
            central.SetActive(true);
        }
    }

    void Update()
    {
        if (state == State.shooting)
        {
            if (aim.delete == true)
            {
                effect[0].enabled = false;
                effect[1].enabled = true;
                state = State.black;
                mask[maskCnt].SetActive(false);
                central.SetActive(true);
            }
        }
        else if (state == State.black)
        {
            if (aim.startFlag == true)
            {
                maskCnt++;
                if(maskCnt >= mask.Length){
                    maskCnt = 0;
                }
                for(int i = 0; i < target.Length; i++) target[i].SetActive(true);
                aim.delete = false;
                effect[0].enabled = true;
                effect[1].enabled = false;
                state = State.shooting;
                mask[maskCnt].SetActive(true);
                central.SetActive(false);
                aim.startFlag = false;
            }
        }
    }
}
