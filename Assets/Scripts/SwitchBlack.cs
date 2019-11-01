using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SwitchBlack : MonoBehaviour
{
    [SerializeField] private float switchTime = 2f;
    [SerializeField] private string blackScene = "Black";

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SwitchScene());
    }

    private IEnumerator SwitchScene(){
        yield return new WaitForSeconds(switchTime);
        SceneManager.LoadScene(blackScene);
    }
}
