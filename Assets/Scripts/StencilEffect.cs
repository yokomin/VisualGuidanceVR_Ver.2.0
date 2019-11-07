using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode, RequireComponent(typeof(Camera))]
public class StencilEffect : MonoBehaviour {
    public Material material;
    protected new Camera camera;

    protected CommandBuffer buffer;
    protected int cachedScreenImageID;

    protected void OnEnable() {
        Init();
        camera.AddCommandBuffer(CameraEvent.AfterForwardAlpha, buffer);        
    }

    protected void OnDisable() {
        camera.RemoveCommandBuffer(CameraEvent.AfterForwardAlpha, buffer);
    }
    protected void Init() {
        if (cachedScreenImageID == 0) { cachedScreenImageID = Shader.PropertyToID("_tempTex"); }

        camera = GetComponent<Camera>();

        if (material == null) {
            material = new Material(Shader.Find("Custom/GaussianBlur")) {
                hideFlags = HideFlags.DontSave
            };
        }


        if (buffer == null){
            buffer = new CommandBuffer {name = "commandBuffer"};

            buffer.GetTemporaryRT(cachedScreenImageID, -1, -1, 0);

            buffer.Blit(BuiltinRenderTextureType.CameraTarget, cachedScreenImageID);
            buffer.Blit(cachedScreenImageID, BuiltinRenderTextureType.CameraTarget, material);
        }
    }    
}